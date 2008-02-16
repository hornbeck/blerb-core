require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
require File.join( File.dirname(__FILE__), "..", "user_spec_helper")
require File.join( File.dirname(__FILE__), "..", "authenticated_system_spec_helper")


describe Users do
  include DefaultSpecHelper
  include DefaultControllerHelper
  include UserSpecHelper
  
  #it_should_behave_like "default controller behavior"  

  before(:each) do
    User.clear_database_table
  end
  
  it 'allows signup' do
     lambda do
       create_user
       controller.should redirect      
     end.should change(User, :count).by(1)
   end
    
   it 'requires password on signup' do
     lambda do
       create_user(:password => nil)
       controller.assigns(:user).errors.on(:password).should_not be_nil
       controller.should be_successful
     end.should_not change(User, :count)
   end
     
   it 'requires password confirmation on signup' do
     lambda do
       create_user(:password_confirmation => nil)
       controller.assigns(:user).errors.on(:password_confirmation).should_not be_nil
       controller.should be_successful
     end.should_not change(User, :count)
   end
   
   it 'requires email on signup' do
     lambda do
       create_user(:email => nil)
       controller.assigns(:user).errors.on(:email).should_not be_nil
       controller.should be_successful
     end.should_not change(User, :count)
   end
   
   it "should have a route for user activation" do
     with_route("/users/activate/1234") do |params|
       params[:controller].should == "Users"
       params[:action].should == "activate" 
       params[:activation_code].should == "1234"    
     end
   end

   it 'activates user' do
     create_user(:email => "aaron@example.com", :password => "test", :password_confirmation => "test")
     @user = controller.assigns(:user)
     User.authenticate('aaron', 'test').should be_nil
     get "/users/activate/1234" 
     controller.should redirect_to("/")
   end

   it 'does not activate user without key' do
       get "/users/activate"
       controller.should be_missing
   end
     
   def create_user(options = {})
      
     post "/users", :user => valid_user_hash.merge(options)
   end
end
