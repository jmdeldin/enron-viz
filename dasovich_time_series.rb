# makes a csv for parsing into matplotlib
#

require_relative 'db'
require_relative 'to_gml'

sender = 'jeff.dasovich@enron.com'

query = <<EOF
select sent
from messages
where sender = '#{sender}'
order by sent asc
EOF

dates = Hash.new(0)

DB[query].each do |row|
  date = row[:sent].strftime('%Y-%m')
  dates[date] += 1
end

fh = File.open('dasovich-dates.csv', 'w')
fh.puts "date, count"
dates.each do |day, count|
  fh.puts "#{day}, #{count}"
end

fh.close
