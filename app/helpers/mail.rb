require 'net/smtp'

module Grapi
  module Email
    def self.send_email(to,opts={})
      opts[:server]      ||= 'localhost'
      opts[:from]        ||= 'email@example.com'
      opts[:from_alias]  ||= 'Example Emailer'
      opts[:subject]     ||= "You need to see this"
      opts[:body]        ||= "Important stuff!"

      msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}
Content-type: text/html

#{opts[:body]}
END_OF_MESSAGE

      Net::SMTP.start(opts[:server], 1025) do |smtp|
        smtp.send_message msg, opts[:from], to
      end
    end
  end
end
