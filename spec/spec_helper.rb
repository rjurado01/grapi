ENV['ENV'] = 'test'

require 'grape'
require 'mongolow'
require 'rack/cors'
require 'require_all'
require 'rack/test'
require 'factory_girl'

require_all 'lib'
require_all 'app'
require_all 'spec/factories'
require_all 'spec/support'

Grapi::Config.load(ENV['ENV'])

Mongolow.initialize
Mongolow::Driver.drop_database

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include ModelValidations
end
