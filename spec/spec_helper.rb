require 'grape'
require 'mongolow'
require 'rack/cors'
require 'require_all'
require 'rack/test'
require 'factory_girl'

require_all 'app'
require_all 'spec/factories'

ENV['ENV'] = 'test'

Mongolow::Driver.initialize('127.0.0.1', 27017, 'grapi_test')
Mongolow::Driver.drop_database

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
