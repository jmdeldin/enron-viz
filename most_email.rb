# This creates a GML file suitable for import into Cytoscape or
# another tool.
#

require_relative 'db'
require_relative 'to_gml'
require_relative 'link'

query = <<EOF
select messages.sender as sender, conversations.email as recipient
from messages
  inner join conversations on conversations.message_id = messages.id
where messages.sent >= '2001-01-01' AND messages.sent < '2002-01-01'
-- where messages.sender = 'jeff.dasovich@enron.com'
--limit 2000
EOF

links = Hash.new(0)

DB[query].each_with_index do |row, i|
  next unless row[:recipient] =~ /enron/i
  row[:recipient].gsub!(%r{</.*>}, '')
  row[:recipient].gsub!(/['"]/, '')

  link = Link.new(row[:sender], row[:recipient])
  links[link] += 1
end

# keep track of the email IDs
nodes = {}

src = 0
dest = 1

links.each do |link, count|
  # get the IDS
  nodes[link.src] ||= src
  nodes[link.dest] ||= dest
  src  += 1
  dest += 1
end

puts "graph [\ndirected 1"
# puts 'digraph  {'
# ghash = {}
# build the GML for just the nodes
nodes.each do |email, id|
  # ghash[email] = "a#{id}"
  # puts "%s [ label=bogus ];" % ghash[email]
  puts node(id, email)
end

# build the edges
links.each do |link, count|
  # puts '%s -- %s [type=0];' % [ghash[link.src], ghash[link.dest]]
  # puts '"%s"->"%s";' % [link.src, link.dest]
  puts connect(nodes[link.src], nodes[link.dest])
end
# puts "}"
puts "]"
