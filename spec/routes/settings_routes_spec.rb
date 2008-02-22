require File.join(File.dirname(__FILE__), 'route_spec_helper')

describe "The settings named routes" do
  
  it "should map url(:edit_settings) to '/admin/settings'" do
    url(:edit_settings).should == "/admin/settings"
  end
  
  it "should map url(:update_settings) to '/admin/settings'" do
    url(:update_settings).should == "/admin/settings"
  end
  
  it "should route GET '/admin/settings' to Admin::Settings#edit" do
    request_to("/admin/settings", :get).should route_to(Admin::Settings, :edit)
  end
  
  it "should route POST '/admin/settings to Admin::Settings#update" do
    request_to("/admin/settings", :post).should route_to(Admin::Settings, :update)
  end
end