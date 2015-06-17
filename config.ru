require 'grape'
require 'mongolow'
require 'rack/cors'
require 'require_all'

require_all 'app'

Mongolow::Driver.initialize('127.0.0.1', 27017, 'database_name')

use Rack::Cors do
  allow do
    origins 'localhost'
    resource '*', headers: :any, methods: :post
  end
end

run Grapi::API
