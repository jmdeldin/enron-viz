require 'sequel'

DB = Sequel.connect("postgres://jmdeldin:@localhost:5432/enron")

query = <<EOF
SELECT messages.id, messages.sender as sender, conversations.email as recipient
FROM messages
  INNER JOIN conversations ON conversations.message_id = messages.id
EOF

puts "digraph enron {"
puts "  rankdir = LR;"
DB[query].each do |row|
  puts '  "%s"->"%s";' % [row[:sender], row[:recipient]]
end

puts "}"
