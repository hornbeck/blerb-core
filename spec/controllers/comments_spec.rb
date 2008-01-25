require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Comments Controller", "index action" do
  before(:each) do
    @controller = Comments.build(fake_request)
    @controller.dispatch('index')
  end
  
  it "should only get " do
    
  end
end