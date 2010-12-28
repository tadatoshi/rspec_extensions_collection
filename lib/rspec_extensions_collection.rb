# The following doesn't work because when this file is loaded by another project, the current directory is in that project:
# Dir[File.join("rspec_extensions_collection/**/*.rb")].each {|f| require f}

require 'rspec_extensions_collection/helpers/mongoid_model_helpers'
require 'rspec_extensions_collection/matchers/search_matcher'
