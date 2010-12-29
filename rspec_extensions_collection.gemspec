# -*- encoding: utf-8 -*-
require File.expand_path("../lib/rspec_extensions_collection/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "rspec_extensions_collection"
  s.version     = RspecExtensionsCollection::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tadatoshi Takahashi"]
  s.email       = ["tadatoshi.3.takahashi@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/rspec_extensions_collection"
  s.summary     = "Collection of various RSpec extensions"
  s.description = "Collection of RSpec extensions incluing helper methods, matchers, and macros that the author would like to use for multiple projects."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rspec_extensions_collection"
  
  s.add_dependency "rspec"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "mongoid-rspec"
  s.add_development_dependency "factory_girl", ">=2.0.0.beta1"  

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
