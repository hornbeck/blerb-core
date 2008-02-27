require 'rubygems'
require 'merb-core'
require 'merb-test'

dir = File.dirname(__FILE__)
require dir / "helpers" / "merb_helpers"
require 'merb-core/test/request_helper'
require 'merb-core/test/fake_request'

$TESTING=true
Merb.start :environment => 'test'

require "#{dir}/spec_helpers/core"
require "#{dir}/spec_helpers/custom_matchers"
require "#{dir}/spec_helpers/shared_behaviors"
require "#{dir}/spec_helpers/app_specific"

#DataMapper::Persistence.auto_migrate!

### METHODS BELOW THIS LINE SHOULD BE EXTRACTED TO MERB ITSELF

def mock_model(klass, fields = {})
  model = mock(klass.name)
  model.stub!(:id).and_return(rand(1000))
  
  fields.each do |m, r|
    model.stub!(m).and_return(r)
  end
  
  model
end