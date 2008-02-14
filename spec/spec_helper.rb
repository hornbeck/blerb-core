require 'rubygems'
require 'spec'
require 'merb-core'

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
end

### METHODS BELOW THIS LINE SHOULD BE EXTRACTED TO MERB ITSELF

