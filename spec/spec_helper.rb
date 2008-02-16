require 'rubygems'
require 'merb-core'
require 'merb-test'

dir = File.dirname(__FILE__)
require dir / "helpers" / "merb_helpers"
require 'merb-core/test/request_helper'
require 'merb-core/test/fake_request'

$TESTING=true
Merb.start :environment => 'test', 
           :adapter     => 'runner'

require Merb.root / "config" / "init" 
require "#{dir}/spec_helpers/core"
require "#{dir}/spec_helpers/custom_matchers"
require "#{dir}/spec_helpers/shared_behaviors"
require "#{dir}/spec_helpers/app_specific"

DataMapper::Persistence.auto_migrate!

Spec::Runner.configure do |config|
    config.include(Merb::Test::Helper)
    config.include(Merb::Test::RequestHelper)
    config.include(Merb::Test::RspecMatchers)
    # TODO should the next two get automagically included somewhere else?
    config.include(Merb::Test::Rspec::ControllerMatchers)
    config.include(Merb::Test::Rspec::MarkupMatchers)
    
end

### METHODS BELOW THIS LINE SHOULD BE EXTRACTED TO MERB ITSELF

def mock_model(klass, fields = {})
  model = mock(klass.name)
  model.stub!(:id).and_return(rand(1000))
  
  fields.each do |m, r|
    model.stub!(m).and_return(r)
  end
  
  model
end

def url(name, params={})
  Merb::Router.generate(name, params)
end

def with_route(path, _method = "GET", env = {}, &block)
  env[:request_method] ||= _method
  env[:request_uri] = path
  
  request = fake_request(env)
  
  opts = check_request_for_route(request)
  
  yield opts if block_given?
  opts
end
