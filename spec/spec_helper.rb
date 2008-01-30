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

# JW -- This is causing failures for me
# DataMapper::Base.auto_migrate!

Spec::Runner.configure do |config|
    config.include(Merb::Test::Helper)
    config.include(Merb::Test::RspecMatchers)
end


### METHODS BELOW THIS LINE SHOULD BE EXTRACTED TO MERB ITSELF

