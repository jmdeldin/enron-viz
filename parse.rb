require 'mail'
require 'sequel'

DB = Sequel.connect("postgres://jmdeldin:@localhost:5432/enron_small")

messages = Dir['messages/maildir/*/*sent*/*']
# messages = Dir['messages/maildir/[p-z]*/*sent*/*']
# messages = Dir['messages/maildir/dasovich-j/*sent*/4292.']
# skip a-c since they were already parsed

size = messages.size
puts "Need to parse #{size} messages!"

messages.each_with_index do |message, i|
  next unless File.file?(message)

  mail = Mail.read(message)

  puts "#{i}/#{size}, #{message}"
  m_data = {
    id:      mail.message_id,
    sent:    mail.date.to_s,
    sender:  mail.from.join,
    subject: mail.subject,
  }


  if mail.to
    if mail.to.is_a? Array
      recipients = mail.to.map { |x| x.to_s.strip }
    else
      recipients = mail.to.split(', ').map { |x| x.to_s.strip }
    end

    if mail.cc
      if mail.cc.is_a? Array
        recipients += mail.cc
      else
        recipients += mail.cc.split(', ').map{|x| x.to_s.strip }
      end
    end
  elsif !mail.to && !mail.header['X-To'].to_s.nil?
    puts "...maybe an internal list"
    hdr = mail.header['X-To'].to_s

    if hdr.scan(/@/).count > 1
      recipients = hdr.split(/,/).reject { |e| e !~ /@/ }.map { |e| e.to_s }
    else
      recipients = [ hdr.to_s ]
    end
  else
    puts "!!> Could not find any recipients...maybe this was a draft"
    next
  end

  recipients = recipients.uniq - mail.from # remove sender, just in case

  begin
    DB[:messages].insert(m_data)
  rescue
    puts "ALREADY PARSED"
    next
  end

  recipients.each do |email|
    r_data = {
      message_id: mail.message_id,
      email:      email,
    }
    DB[:conversations].insert(r_data)
  end

end




