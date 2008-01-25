MERB_ENV="test" unless Object.const_defined?('MERB_ENV')
$TESTING=true
require File.join(File.dirname(__FILE__), "..", 'config', 'boot')
require File.join(MERB_ROOT, 'config', 'merb_init')

require 'merb/test/helper'
require 'merb/test/rspec'

DataMapper::Base.auto_migrate!
### METHODS BELOW THIS LINE SHOULD BE EXTRACTED TO MERB ITSELF

def fake_render(template, ivars={})
  dummy = Object.new
  ivars.each do |key, value|
    dummy.instance_variable_set "@#{key.to_s}", value
  end
  template = "#{MERB_VIEW_ROOT}/#{template}"
  engine = Merb::Template.engine_for(template)
  view_context = Merb::ViewContext.new dummy
  engine.transform(:file => template, :view_context => view_context)
end
