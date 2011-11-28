# generates graphviz output for a radial layout figure
# repeated contacts are drawn with thicker edges

require_relative 'db'
# sender = "phillip.allen@enron.com"
# sender = 'kenneth.lay@enron.com'
sender = 'jeff.dasovich@enron.com'
query = <<EOF
select messages.sender,
  conversations.email as recipient,
  count(*) as num_emails
from messages
  inner join conversations on conversations.message_id = messages.id
where messages.sender = '#{sender}'
group by messages.sender, conversations.email
having count(*) > 1
order by num_emails DESC
LIMIT 300
EOF

weights = {}
raw_weights = []
DB[query].each do |row|
  raw_weights << row[:num_emails]
end

raw_weights.sort.each do |w|
  next if weights[w]

  if biggest = weights.values.max
    weights[w] = biggest + 0.2
  else
    weights[w] = 1.0
  end

end

puts <<EOF
digraph spread {
  ranksep = "2.0,5.0";
  size="8,8";

  layout=neato;

  overlap=false;
  splines=true;
  pack=true;
  start="random";
  sep=0.4;
  edge[len=2];
//  nodesep = 2.0;
//  ratio=expand;
//  size="7.75,10.25";

EOF
# puts '  node [ fontsize=8 ]; '
puts '  src [ label="%s" ];' % [sender]

nodes = {}
DB[query].each_with_index do |row, i|
  next unless row[:recipient] =~ /enron/i
  nodes[row[:recipient]] ||= "rec#{i}"
  n = nodes[row[:recipient]]

  em = row[:recipient]
  # em = em.gsub(/@.*enron.*/i, '').downcase
  puts '  %s [ label="%s" ];' % [n, em]

  puts '  %s->%s [ penwidth = %d l];' % ['src', n, 1] #weights[row[:num_emails]]]

end


puts '}'
