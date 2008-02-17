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

def request_to(path, method = :get, env = {})
  env[:request_method] ||= method.to_s.upcase
  env[:request_uri] = path
  
  check_request_for_route(fake_request(env))
end

class RouteToMatcher
  def initialize(klass_or_name, action)
    @expected_controller = Class === klass_or_name ? klass_or_name.name : klass_or_name
    @expected_action = action.to_s
  end
  
  def matches?(target)
    @target_controller, @target_action = target[:controller], target[:action]
    @expected_controller == @target_controller && @expected_action == @target_action
  end
  
  def failure_message
    "expected the request to route to #{@expected_controller}##{@expected_action}, but was #{@target_controller}##{@target_action}"
  end
  
  def negative_failure_message
    "expected the request not to route to #{@expected_controller}##{@expected_action}, but it did"
  end
end

def route_to(klass_or_name, action)
  RouteToMatcher.new(klass_or_name, action)
end