require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "/users" do
  before(:each) do
    @controller,@action = get("/users")
    @body = @controller.body
  end

  it "should mention Users" do
    @body.should match(/Users/)
  end
end