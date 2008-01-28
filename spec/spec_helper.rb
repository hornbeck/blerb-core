dir = File.dirname(__FILE__)
$TESTING=true
require File.join(dir, "..", 'config', 'boot')
Merb.environment="test"
require File.join(Merb.root, 'config', 'merb_init')

require 'merb/test/helper'
require 'merb/test/rspec'

require "#{dir}/spec_helpers/core"
require "#{dir}/spec_helpers/custom_matchers"
require "#{dir}/spec_helpers/shared_behaviors"
require "#{dir}/spec_helpers/app_specific"

Spec::Runner.configure do |config|
    config.include(Merb::Test::Helper)
    config.include(Merb::Test::RspecMatchers)
end


### METHODS BELOW THIS LINE SHOULD BE EXTRACTED TO MERB ITSELF

def fake_render(template, ivars={})
  dummy = Object.new
  ivars.each do |key, value|
    dummy.instance_variable_set "@#{key.to_s}", value
  end
  template = "#{Merb.root}/app/views/#{template}"
  engine = Merb::Template.engine_for(template)
  view_context = Merb::ViewContext.new dummy
  engine.transform(:file => template, :view_context => view_context)
end