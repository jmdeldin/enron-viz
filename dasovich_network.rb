# makes a csv for parsing into matplotlib
#

require_relative 'db'
require_relative 'link'
require_relative 'to_gml'

sender = 'jeff.dasovich@enron.com'

get_inner_circle = <<EOF
select messages.sender,
  conversations.email as recipient,
  count(*) as num_emails
from messages
  inner join conversations on conversations.message_id = messages.id
where messages.sender = '#{sender}'
group by messages.sender, conversations.email
having count(*) > 5
order by num_emails DESC
limit 15;
EOF

edges = []
sender.gsub!(/@enron.com/i, '')
DB[get_inner_circle].each_with_index do |row, i|
  row[:recipient].gsub!(/@enron.com/i, '')
  edges << Link.new(sender, row[:recipient], {weight: row[:num_emails]})
end

nodes = {}
src = 0
dest = 1
edges.each do |edge|
  nodes[edge.src] ||= src
  nodes[edge.dest] ||= dest
  src += 1
  dest += 1
end

puts "graph [\ndirected 1"
nodes.each do |email, id|
  puts node(id, email)

end
edges.each do |edge|
  puts edge(nodes[edge.src], nodes[edge.dest], {emails: edge.extra[:weight]})
end
puts ']'

