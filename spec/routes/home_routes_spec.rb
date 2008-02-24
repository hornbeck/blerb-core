require File.join(File.dirname(__FILE__), 'route_spec_helper')

describe "The home named routes" do
  it "should map url(:home) to '/'" do
    url(:home).should == "/"
  end
  
  it "should map url(:admin_home) to '/admin'" do
    url(:admin_home).should == "/admin"
  end
  
  it "should route GET '/' to Articles#index" do
    request_to("/").should route_to(Articles, :index)
  end
  
  it "should route GET '/admin/' to Admin::Articles#index" do
    request_to("/admin").should route_to(Admin::Articles, :index)
  end
end