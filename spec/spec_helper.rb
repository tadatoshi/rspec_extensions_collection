require 'rspec'
require 'rspec/core'
require 'rspec/expectations'
require 'mongoid'
require 'factory_girl'
require 'factories'
Dir[File.expand_path(File.join(File.dirname(__FILE__), '/../lib/', 'rspec_extensions_collection/**/*.rb'))].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "models/**/*.rb")].each {|f| require f}

Mongoid.configure do |config|
  name = "rspec_extensions_collection_test"
  host = "localhost"
  config.master = Mongo::Connection.new.db(name)
end

RSpec.configure do |config|
  # config.include RSpec::Matchers
  # config.include Mongoid::Matchers
  config.mock_with :rspec
  
  config.include RSpecExtensionsCollection::Matchers
end