require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "/comments" do
  before(:each) do
    @controller,@action = get("/comments")
    @body = @controller.body
  end

  it "should mention Comments" do
    @body.should match(/Comments/)
  end
end