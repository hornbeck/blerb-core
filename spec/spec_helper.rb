require 'rubygems'
require 'merb-core'

dir = File.dirname(__FILE__)
require dir / "helpers" / "merb_helpers"
require 'merb-core/test/helpers'

Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

require "#{dir}/spec_helpers/core"
require "#{dir}/spec_helpers/custom_matchers"
require "#{dir}/spec_helpers/shared_behaviors"
require "#{dir}/spec_helpers/app_specific"

### METHODS BELOW THIS LINE SHOULD BE EXTRACTED TO MERB ITSELF

def mock_model(klass, fields = {})
  model = mock(klass.name)
  model.stub!(:id).and_return(rand(1000))
  
  fields.each do |m, r|
    model.stub!(m).and_return(r)
  end
  
  model
end
