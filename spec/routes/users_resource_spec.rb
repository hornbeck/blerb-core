require File.join(File.dirname(__FILE__), 'route_spec_helper')

describe "The users resource" do
  it "should map url(:signup) to '/signup'" do
    url(:signup).should == "/signup"
  end
  
  it "should map url(:user_activation, :activation_code => 123) to '/users/activate/123'" do
    url(:user_activation, :activation_code => 123).should == "/users/activate/123"
  end
  
  it "should map url(:users) to '/users'" do
    url(:users).should == "/users"
  end
  
  it "should map url(:new_user) to '/users/new'" do
    url(:new_user).should == "/users/new"
  end
  
  it "should map url(:edit_user, @user) to '/users/<user_id>/edit" do
    @user = mock_model(User)
    
    url(:edit_user, @user).should == "/users/#{@user.id}/edit"
  end
  
  it "should map url(:delete_url, @user) to '/users/<user_ud>/delete" do
    @user = mock_model(User)
    
    url(:delete_user, @user).should == "/users/#{@user.id}/delete"
  end
  
  it "should route GET '/signup' to Users#new" do
    request_to("/signup").should route_to(Users, :new)
  end
  
  it "should route GET '/users/activate/abc' to Users#activate_user with {:activation_code => 'abc'}" do
    request_to("/users/activate/abc").should route_to(Users, :activate).with(:activation_code => 'abc')
  end
  
  it "should route GET '/users' to Users#index" do
    request_to("/users").should route_to(Users, :index)
  end
  
  it "should route GET '/users/new' to Users#new" do
    request_to("/users/new").should route_to(Users, :new)
  end
  
  it "should route GET '/users/101/edit' to Users#edit with {:id => '101'}" do
    request_to("/users/101/edit").should route_to(Users, :edit).with(:id => '101')
  end
  
  it "should route PUT '/users/101' to Users#update with {:id => '101'}" do
    request_to("/users/101", :put).should route_to(Users, :update).with(:id => '101')
  end
  
  it "should route GET '/users/101/delete' to Users#delete with {:id => '101'}" do
    request_to("/users/101/delete").should route_to(Users, :delete).with(:id => '101')
  end
  
  it "should route DELETE '/users/101' to Users#destroy with {:id => '101'}" do
    request_to("/users/101", :delete).should route_to(Users, :destroy).with(:id => '101')
  end
end