# This creates a GML file suitable for import into Cytoscape or
# another tool.
#

require_relative 'db'
require_relative 'to_gml'

sender = ARGV.first
abort 'Usage: %s EMAIL' % File.basename(__FILE__) if ARGV.empty?

query = <<EOF
select messages.sender,
  conversations.email as recipient,
  count(*) as num_emails
from messages
  inner join conversations on conversations.message_id = messages.id
where messages.sender = '#{sender}'
group by messages.sender, conversations.email
having count(*) > 5
order by num_emails DESC
EOF

root_id = '8675309'
puts <<EOF
graph [
  directed 1

  node [
    id #{root_id}
    label "#{sender}"
    nweight 0
    node_type source
  ]
EOF

# keep track of node ids based on email => id
nodes = {}

DB[query].each_with_index do |row, i|
  nodes[row[:recipient]] ||= i
  id = nodes[row[:recipient]]
  weight = row[:num_emails]

  puts node(id, row[:recipient], {nweight: weight, node_type: 'target'})
  puts connect(root_id, id, "  weight %d" % weight)
end

puts "]"
