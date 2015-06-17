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

    mount Grapi::SessionsAPI
    mount Grapi::PostsAPI
  end
end
