require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
require File.join( File.dirname(__FILE__), "..", "user_spec_helper")
require File.join( File.dirname(__FILE__), "..", "authenticated_system_spec_helper")

describe Users do
  
  include UserSpecHelper
  
  before(:each) do
    # User.clear_database_table
  end
  
  it 'allows signup' do
    pending
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
     pending
       get "/users/activate"
       controller.should be_missing
   end
     
   def create_user(options = {})
     pending
     post "/users", :user => valid_user_hash.merge(options)
   end
end


describe Users do
  include UserSpecHelper
  
  before(:each) do
    @user = mock_model(User, valid_user_hash)
  end
  
  describe 'succesfully creating user' do
    before(:each) do

      User.stub!(:new).and_return(@user)

      @user.stub!(:save).and_return(true)
      
      @params = {:user => @user}
    end
    
    it "should delete auth cookies" do
      dispatch_to(Users, :create, @params) do
        self.cookies.should_receive(:delete).with(:auth_token)
      end
    end
    
    it "should save the user" do
      @user.should_receive(:save).and_return(true)
      dispatch_to(Users, :create, @params)
    end
    
    it "should redirect" do
      dispatch_to(Users, :create, @params).should be_redirect
    end
    
    it "should redirect to /" do
      dispatch_to(Users, :create, @params).should redirect_to('/')
    end
  end
  
end