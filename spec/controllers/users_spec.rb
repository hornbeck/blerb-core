require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Users Controller", "index action (logged in)" do
  before(:each) do
    @controller = Users.build(fake_request)
    @controller.dispatch('index')
  end
  
  it "should return all users"
  
end

describe "Users Controller", "index action (not logged in)" do
  
  it "should not return any users"
  
end

describe "Users Controller", "show action" do
  
  it "should return only the one user"
  
end

describe "Users Controller", "destroy action" do
  
  it "should destroy the one user"
  
end