require 'grape'
require 'mongolow'
require 'rack/cors'
require 'require_all'

require_all 'lib'
require_all 'app'

# initialize enviroment
ENV['ENV'] = 'development' unless ENV['ENV']

# initialize database
Mongolow.initialize

# load grapi configs
Grapi::Config.load(ENV['ENV'])

use Rack::Cors do
  allow do
    origins 'localhost'
    resource '*', headers: :any, methods: :post
  end
end

run Grapi::API
