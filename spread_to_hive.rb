# for http://wodaklab.org/hivegraph/

require_relative 'db'

sender = "phillip.allen@enron.com"
query = <<EOF
select messages.sender,
  conversations.email as recipient,
  count(*) as num_emails
from messages
  inner join conversations on conversations.message_id = messages.id
where messages.sender = '#{sender}'
group by messages.sender, conversations.email
-- having count(*) > 1
order by num_emails DESC
EOF

query2 = <<EOF
select messages.sender,
  conversations.email as recipient
from messages
  inner join conversations on conversations.message_id = messages.id
where messages.sender = 'phillip.allen@enron.com'
EOF


nodes = File.open('nodes.csv', 'w')
links = File.open('links.csv', 'w')

nodes.puts "id	axis	label	value	height	r	g	b	a"
nodes.puts %w(zsrc z SOURCE 5 10 255 0 0 0 200).join("\t")

links.puts "start node label	end node label"

value = 0
DB[query].each_with_index do |row, i|
  axis = %w(a b c).sample
  id   = "#{axis}-#{i}"
  label = row[:recipient]
  value += 10
  height = [10, 5, 1, 2].sample
  r = 200
  g = 100
  b = 50
  a = 200
  nodes.puts [id, axis, label, value, height, r, g, b, a].join("\t")
  links.puts ['zsrc', id].join("\t")
end

nodes.close
links.close
