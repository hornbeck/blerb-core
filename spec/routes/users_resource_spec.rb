require File.join(File.dirname(__FILE__), 'route_spec_helper')

describe "The users resource" do
  it "should map url(:new_user) to '/admin/users/new'" do
    url(:new_user).should == "/admin/users/new"
  end

  it "should map url(:user_activation, :activation_code => 123) to '/users/activate/123'" do
    url(:user_activation, :activation_code => 123).should == "/users/activate/123"
  end

  it "should map url(:users) to '/admin/users'" do
    url(:users).should == "/admin/users"
  end

  it "should map url(:new_user) to '/admin/users/new'" do
    url(:new_user).should == "/admin/users/new"
  end

  it "should map url(:edit_user, @user) to '/users/<user_id>/edit" do
    @user = mock_model(User)

    url(:edit_user, @user).should == "/admin/users/#{@user.id}/edit"
  end

  it "should map url(:delete_url, @user) to '/admin/users/<user_ud>/delete" do
    @user = mock_model(User)

    url(:delete_user, @user).should == "/admin/users/#{@user.id}/delete"
  end

  it "should route GET '/admin/users/new' to Admin::Users#new" do
    request_to("/admin/users/new").should route_to(Admin::Users, :new)
  end

  it "should route POST '/admin/users/new' to Admin::Users#create" do
    request_to("/admin/users/new", :post).should route_to(Admin::Users, :create)
  end

  it "should route GET '/users/activate/abc' to Users#activate_user with {:activation_code => 'abc'}" do
    request_to("/users/activate/abc").should route_to(Users, :activate).with(:activation_code => 'abc')
  end

  it "should route GET '/users' to Users#index" do
    request_to("/admin/users").should route_to(Admin::Users, :index)
  end

  it "should route GET '/admin/users/new' to Users#new" do
    request_to("/admin/users/new").should route_to(Admin::Users, :new)
  end

  it "should route GET '/admin/users/101/edit' to Admin::Users#edit with {:id => '101'}" do
    request_to("/admin/users/101/edit").should route_to(Admin::Users, :edit).with(:id => '101')
  end

  it "should route PUT '/admin/users/101' to Admin::Users#update with {:id => '101'}" do
    request_to("/admin/users/101", :put).should route_to(Admin::Users, :update).with(:id => '101')
  end

  it "should route GET '/admin/users/101/delete' to Admin::Users#delete with {:id => '101'}" do
    request_to("/admin/users/101/delete").should route_to(Admin::Users, :delete).with(:id => '101')
  end

  it "should route DELETE '/admin/users/101' to Admin::Users#destroy with {:id => '101'}" do
    request_to("/admin/users/101", :delete).should route_to(Admin::Users, :destroy).with(:id => '101')
  end
end