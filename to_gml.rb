def node(id, label, extra = {})
  tmp = []
  extra.merge!({id: id, label: label})

  extra.each do |key, value|
    if value.is_a? String
      tmp << '  %s "%s"' % [key.to_s, value]
    else
      tmp << '  %s %d' % [key.to_s, value.to_i]
    end
  end
  "node [\n" + tmp.join("\n") + "\n]"
end

def edge(src, dest, extra = {})
  s = ['edge [']
  extra.merge!({source: src, target: dest})
  extra.each do |key, value|
    s << '  %s %d' % [key, value]
  end
  s << ']'
  s.join("\n")
end

def connect(src, dest, extra = '')
  [
    'edge [',
    "  source #{src}",
    "  target #{dest}",
    extra,
    ']',
  ].join("\n")
end
