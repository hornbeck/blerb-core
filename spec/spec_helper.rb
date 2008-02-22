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

### METHODS BELOW THIS LINE SHOULD BE EXTRACTED TO MERB ITSELF

def mock_model(klass, fields = {})
  model = mock(klass.name)
  model.stub!(:id).and_return(rand(1000))
  
  fields.each do |m, r|
    model.stub!(m).and_return(r)
  end
  
  model
end

module Merb::Test::RouteHelper
  include Merb::Test::RequestHelper
  
  def url(name, params={})
    Merb::Router.generate(name, params)
  end

  def request_to(path, method = :get, env = {})
    env[:request_method] ||= method.to_s.upcase
    env[:request_uri] = path

    check_request_for_route(fake_request(env))
  end
end

module Merb::Test::Rspec::RouteMatchers
  include Merb::Test::RouteHelper
  
  class RouteToMatcher
    def initialize(klass_or_name, action)
      @expected_controller = Class === klass_or_name ? klass_or_name.name : klass_or_name
      @expected_action = action.to_s
    end
  
    def matches?(target)
      @target_env = target.dup
      @target_controller, @target_action = @target_env.delete(:controller).to_s, @target_env.delete(:action).to_s
      
      @target_controller = "#{target.delete(:namespace)}::#{@target_controller}" if target.has_key?(:namespace)
      
      @expected_controller.snake_case == @target_controller.snake_case && @expected_action == @target_action && match_parameters(@target_env)
    end
  
    def match_parameters(target)
      @parameter_matcher.nil? ? true : @parameter_matcher.matches?(target)
    end
  
    def with(parameters)
      @paramter_matcher = ParameterMatcher.new(parameters)
      
      self
    end
  
    def failure_message
      "expected the request to route to #{camelize(@expected_controller)}##{@expected_action}, but was #{camelize(@target_controller)}##{@target_action}"
    end
  
    def negative_failure_message
      "expected the request not to route to #{camelize(@expected_controller)}##{@expected_action}, but it did"
    end
    
    def camelize(word)
      word.to_s.gsub(/^[a-z]|(\_[a-z])/) { |a| a.upcase.gsub("_", "") }
    end
  end

  class ParameterMatcher
    def initialize(hash_or_object)
      @expected = {}
      case hash_or_object
      when Hash then @expected = hash_or_object
      else @expected[:id] = hash_or_object.to_param
      end
    end
  
    def matches?(parameter_hash)
      @actual = parameter_hash.dup.except(:controller, :action)
    
      @expected.all? {|(k, v)| @actual.has_key?(k) && @actual[k] == v}
    end
  
    def failure_message
      "expected the route to contain parameters #{@expected.inspect}, but instead contained #{@actual.inspect}"
    end
  
    def negative_failure_message
      "expected the route not to contain parameters #{@expected.inspect}, but it did"
    end
  end
  
  # Passes when the actual route parameters match the expected controller class and
  # controller action.  Exposes a +with+ method for specifying parameters.
  #
  # ==== Paramters
  # klass_or_name<Class, String>::
  #   The type or type name of the expected controller.
  # action<Symbol, String>:: Method name of the action.  Works with strings or symbols.
  # ==== Example
  #   # Passes if a GET request to "/" is routed to the Widgets controller's index action.
  #   request_to("/", :get).should route_to(Widgets, :index)
  #
  #   # Use the 'with' method for parameter checks
  #   request_to("/123").should route_to(widgets, :show).with(:id => "123")
  #
  def route_to(klass_or_name, action)
    RouteToMatcher.new(klass_or_name, action)
  end
end