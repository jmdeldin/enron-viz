# This creates a GML file suitable for import into Cytoscape or
# another tool.
#

require_relative 'db'

sender = ARGV.first
abort 'Usage: %s EMAIL' % File.basename(__FILE__) if ARGV.empty?

query = <<EOF
select
  conversations.email as recipient,
  messages.sent as date
from conversations
  inner join messages on messages.id = conversations.message_id and messages.sender = '#{sender}'
EOF

puts "email\tdate"
DB[query].each_with_index do |row, i|
  puts [row[:recipient], row[:date]].join("\t")
end
