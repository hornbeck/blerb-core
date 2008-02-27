require File.join(File.dirname(__FILE__), 'controller_spec_helper.rb')
require File.join( File.dirname(__FILE__), "..", "user_spec_helper")
require File.join( File.dirname(__FILE__), "..", "authenticated_system_spec_helper")


describe Users do
  include DefaultSpecHelper
  include DefaultControllerHelper
  include UserSpecHelper
  
  #it_should_behave_like "default controller behavior"  

  before(:each) do
    @user = mock_model(User, valid_user_hash)
    @activation_code = 'yyz'
  end
  
  describe '#create with valid user' do
    before(:each) do
      User.stub!(:new).and_return(@user)
      @user.stub!(:save).and_return(true)
      @params = {:user => valid_user_hash}
    end
    
    it "should delete auth cookies" do
      dispatch_to(Users, :create, @params) do |controller|
        controller.cookies.should_receive(:delete).with(:auth_token)
      end
    end
    
    it "should save the user" do
      @user.should_receive(:save).and_return(true)
      dispatch_to(Users, :create, @params)
    end
    
    it "should redirect" do
      dispatch_to(Users, :create, @params).should be_redirected
    end
    
    it "should redirect to /" do
      dispatch_to(Users, :create, @params).should redirect_to('/')
    end
  end
  
  describe "#create with invalid user" do
    before(:each) do
      User.stub!(:new).and_return(@user)
      @user.stub!(:save).and_return(false)
      @params = {:user => valid_user_hash}
    end
    
    it "should delete auth cookies" do
      dispatch_to(Users, :create, @params) do |controller|
        controller.cookies.should_receive(:delete).with(:auth_token)
      end
    end
    
    it "should save the user" do
      @user.should_receive(:save).and_return(false)
      dispatch_to(Users, :create, @params)
    end
    
    it "should render the 'new' template" do
      dispatch_to(Users, :create, @params) do |controller|
        controller.should_receive(:render).with(:new)
      end
    end
  end
  
  describe "#activate an inactive user" do
    before(:each) do
      @params = {:activation_code => @activation_code}
      @user.stub!(:active?).and_return(false)
      User.stub!(:find_activated_authenticated_model).with(@activation_code).and_return(@user)
      @user.stub!(:activate)
    end
    
    it "should lookup activated authenticated model" do
      User.should_receive(:find_activated_authenticated_model).with(@activation_code).and_return(@user)
      dispatch_to(Users, :activate, @params)
    end
    
    it "should activate the user" do
      @user.should_receive(:activate)
      dispatch_to(Users, :activate, @params)
    end
    
    it "should redirect" do
      dispatch_to(Users, :activate, @params).should be_redirected
    end
    
    it "should redirect to '/'" do
      dispatch_to(Users, :activate, @params).should redirect_to('/')
    end
  end
  
  describe "#activate an active user" do
    before(:each) do
      @params = {:activation_code => @activation_code}
      @user.stub!(:active?).and_return(true)
      User.stub!(:find_activated_authenticated_model).with(@activation_code).and_return(@user)
    end
    
    it "should lookup activated authenticated model" do
      User.should_receive(:find_activated_authenticated_model).with(@activation_code).and_return(@user)
      dispatch_to(Users, :activate, @params)
    end
    
    it "should not activate the user" do
      @user.should_not_receive(:activate)
      dispatch_to(Users, :activate, @params)
    end
    
    it "should redirect" do
      dispatch_to(Users, :activate, @params).should be_redirected
    end
    
    it "should redirect to '/'" do
      dispatch_to(Users, :activate, @params).should redirect_to('/')
    end
  end
  
  describe "#activate a non-existent user" do
    before(:each) do
      @params = {:activation_code => @activation_code}
      User.stub!(:find_activated_authenticated_model).with(@activation_code).and_return(nil)
    end
    
    it "should lookup activated authenticated model" do
      User.should_receive(:find_activated_authenticated_model).with(@activation_code).and_return(@user)
      dispatch_to(Users, :activate, @params) do |controller|
        controller.stub!(:logged_in?).and_return(false)
      end
    end
    
    it "should redirect" do
      controller = dispatch_to(Users, :activate, @params) do |controller|
        controller.stub!(:logged_in?).and_return(false)
      end
      
      controller.should be_redirected
    end
    
    it "should redirect to '/'" do
      controller = dispatch_to(Users, :activate, @params) do |controller|
        controller.stub!(:logged_in?).and_return(false)
      end
      
      controller.should redirect_to('/')
    end
  end
  
  

  #it 'allows signup' do
  #   calling do
  #     controller = create_user
  #     controller.should redirect
  #   end.should change(User, :count).by(1)
  # end
    
   it 'requires password on signup' do
     lambda do
       controller = create_user(:password => nil)
       controller.assigns(:user).errors.on(:password).should_not be_nil
       controller.should be_successful
     end.should_not change(User, :count)
   end
     
   it 'requires password confirmation on signup' do
     lambda do
       controller = create_user(:password_confirmation => nil)
       controller.assigns(:user).errors.on(:password_confirmation).should_not be_nil
       controller.should be_successful
     end.should_not change(User, :count)
   end
   
   it 'requires email on signup' do
     lambda do
       controller = create_user(:email => nil)
       controller.assigns(:user).errors.on(:email).should_not be_nil
       controller.should be_successful
     end.should_not change(User, :count)
   end
   
   it 'activates user' do
     controller = create_user(:email => "aaron@example.com", :password => "test", :password_confirmation => "test")
     @user = controller.assigns(:user)
     User.authenticate('aaron', 'test').should be_nil
     get "/users/activate/1234" 
     controller.should redirect_to(url(:user, @user))
   end
   
   #Commented out b/c its routing to User#show
   #it 'does not activate user without key' do
   #  controller = get "/users/activate"
   #  controller.should be_missing
   #end
     
   def create_user(options = {})
     dispatch_to(Admin::Users, :create, :user => valid_user_hash.merge(options))
   end
end
