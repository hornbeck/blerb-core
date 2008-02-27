require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

Spec::Runner.configure do |config|
  config.include(Merb::Test::Rspec::ControllerMatchers)
end

### METHODS BELOW THIS LINE SHOULD BE EXTRACTED TO MERB ITSELF