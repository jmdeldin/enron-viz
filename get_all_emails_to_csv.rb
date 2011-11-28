# This creates a GML file suitable for import into Cytoscape or
# another tool.
#

class Link
  attr_reader :src, :dest

  def initialize(src, dest)
    @src = src
    @dest = dest
  end

  def ==(o)
    return false unless o.is_a? self.class

    self.instance_variables.each do |v|
      return false if self.instance_variable_get(v) != o.instance_variable_get(v)
    end
    true
    end

  # True if the other object is the same instance and all of the
  # object's instance variables are equal.
  #
  def eql?(o)
    if o.instance_of? self.class
      self.instance_variables.each do |v|
        return false if self.instance_variable_get(v) != o.instance_variable_get(v)
      end
      true
    else
      false
    end
  end

  # Hash codes from /Effective Java/ via /The Ruby Programming Language/.
  #
  def hash
    code = 17
    code = 37 * code
    self.instance_variables.each do |v|
      code += self.instance_variable_get(v).hash
    end
    code
  end
end

require_relative 'db'
require_relative 'to_gml'

query = <<EOF
select messages.sender as sender, conversations.email as recipient
from messages
  inner join conversations on conversations.message_id = messages.id
where messages.sender = 'jeff.dasovich@enron.com'

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


# build the GML for just the nodes
nodes.each do |email, id|
end

puts 'digraph g {'
# build the edges
links.each do |link, count|
  puts '"%s"->"%s"' % [link.src, link.dest]
end

puts '}'
