require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

Spec::Runner.configure do |config|
  config.include(Merb::Test::Rspec::RouteMatchers)
end

### METHODS BELOW THIS LINE SHOULD BE EXTRACTED TO MERB ITSELF

#describe "a RESTful resource", :shared => true do
#  
#  it "should route GET '/signup' to Users#new" do
#    @resource.should_not be_nil
#    
#    request_to("/#{@resource.name}".downcase).should route_to(@resource, :index)
#  end
#  
#  it "should route " do
#    
#  end
#end