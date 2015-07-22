module Templates
  module User
    def session_tmpl(options)
      {
        "id" => self.id,
        "email" => self.email,
        "session_token" => self.session_token
      }
    end
  end
end
