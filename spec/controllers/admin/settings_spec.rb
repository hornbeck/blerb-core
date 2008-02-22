require File.join(File.dirname(__FILE__), '..', 'controller_spec_helper.rb')

describe "Admin::Settings Controller", "edit action" do
  before(:each) do
    @controller = Admin::Settings.build(fake_request)
    @controller.dispatch('edit')
  end
end