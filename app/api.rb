module Grapi
  class API < Grape::API
    version 'v1', :using => :header, :vendor => 'grapi', :format => :json
    format :json

    helpers do
      include Grapi::Params 
      include Grapi::Response
      include Grapi::Pagination
      include Grapi::Authentication
    end

    mount Grapi::PostsAPI

    # authentication
    mount Grapi::RegistrationsAPI
    mount Grapi::ConfirmationsAPI
    mount Grapi::PasswordsAPI
    mount Grapi::SessionsAPI
  end
end
