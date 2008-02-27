require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

Spec::Runner.configure do |config|
  config.include(Merb::Test::Rspec::ControllerMatchers)
  config.include(Merb::Test::Rspec::ControllerMatchers)
end