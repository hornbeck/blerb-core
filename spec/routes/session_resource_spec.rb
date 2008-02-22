require File.join(File.dirname(__FILE__), 'route_spec_helper')

describe "The session resource" do
  it "should map url(:login) to '/login'" do
    url(:login).should == "/login"
  end
  
  it "should map url(:logout) to '/logout'" do
    url(:logout).should == "/logout"
  end
  
  it "should route GET '/login' to Session#login" do
    request_to("/login").should route_to(Session, :new)
  end
  
  it "should route POST '/login' to Session#create" do
    request_to("/login", :post).should route_to(Session, :create)
  end
  
  it "should route '/logout' to Session#logout" do
    request_to("/logout").should route_to(Session, :destroy)
  end
end