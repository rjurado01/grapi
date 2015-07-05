require 'net/smtp'
require 'erb'

class Prueba
  @@hola = nil

  def self.hola
    @@hola
  end
end

module Grapi
  class Mail
    attr_accessor :server, :to, :from, :subject, :template, :port

    @@last_email = nil

    def self.last_email
      @@last_email
    end

    def initialize
      @port = ENV['SMTP_PORT']
      @server = ENV['SMTP_SERVER']
      @from = ENV['SMTP_FROM']
    end

    def send
      if ENV['ENV'] == 'test'
        @@last_email = self
      else
        Net::SMTP.start(self.server, self.port) do |smtp|
          smtp.send_message get_message, self.from, to
        end
      end
    end

    private

    def get_body
      template_path = 'app/mailers/templates/' + template

      if File.exist?(template_path)
        ERB.new(File.read(template_path)).result(binding)
      else
        raise "Mail > Template doesn't exist."
      end
    end

    def get_message
      msg = <<END_OF_MESSAGE
From: <#{self.from}>
To: <#{self.to}>
Subject: #{self.subject}
Content-type: text/html

#{get_body}
END_OF_MESSAGE
    end
  end
end
