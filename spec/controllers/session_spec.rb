require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
require File.join( File.dirname(__FILE__), "..", "user_spec_helper")
require File.join( File.dirname(__FILE__), "..", "authenticated_system_spec_helper")

describe Session, "logging in successfully" do
  before(:each) do
    @user = mock_model(User, :email => 'quentin@example.com', :password => 'test')
    User.stub!(:authenticate).with(@user.email, @user.password).and_return(@user)
  end
  
  it 'should redirect' do
    do_it
    @controller.should be_redirect
    # controller.session[:user].should_not be_nil
    # controller.session[:user].should == @quentin.id
    # pending
    # controller.should redirect_to("/")
  end
  
  it 'should redirect to route' do
    do_it
    @controller.should redirect_to('/')
  end
  
  it 'should update the session' do
    do_it
    @controller.session[:user].should_not be_nil
    @controller.session[:user].should == @user.id
  end
  
  it 'should authenticate the user' do
    User.stub!(:authenticate).with(@user.email, @user.password).and_return(@user)
    do_it
  end
  
  it 'should not remember me' do
    do_it
    @controller.cookies["auth_token"].should be_nil
  end
  
  def do_it
    @controller = dispatch_to(Session, :create, :email => @user.email, :password => @user.password)
  end
end

describe Session, 'logging in successfully, and setting "remember me"' do
  before(:each) do
    @expiration = Time.now + Merb::Const::WEEK * 2
    @user = mock_model(User,
      :email => 'quentin@example.com', :password => 'test',
      :remember_token => 'sekrit', :remember_token_expires_at => @expiration)
    User.stub!(:authenticate).with(@user.email, @user.password).and_return(@user)
    @user.stub!(:remember_me)
  end
  
  it "should persist auth token in cookies" do
    do_it
    @controller.cookies['auth_token'].should_not be_nil
    @controller.cookies['auth_token'].should == @user.remember_token
  end
  
  it "should remember the user" do
    @user.should_receive(:remember_me)
    do_it
  end
  
  def do_it
    @controller = dispatch_to(Session,
      :create, :email => @user.email,
      :password => @user.password,
      :remember_me => 1)
  end
end


describe Session, 'failing to login' do
  
  before(:each) do
    @user = mock_model(User, :email => 'quentin@example.com', :password => 'bad pasword')
    User.stub!(:authenticate).with(@user.email, @user.password).and_return(nil)
  end
  
  it "should not redirect" do
    do_it
    @controller.should_not be_redirect
  end
  
  it "should not populate the session" do
    do_it
    @controller.session[:user].should be_nil
  end
  
  it "should have 'success' status code" do
    do_it
    @controller.should be_success
  end
  
  it "should a login form" do
    do_it
    @controller.body.should have_tag(:form, :action => '/session')
  end
  
  def do_it
    @controller = dispatch_to(Session, :create, :email => @user.email, :password => @user.password)
  end
end


#Another style of spec'n
describe Session do
  before(:each) do
    @params = {:email => 'quentin@example.com', :password => 'test'}
    @user = mock_model(User, @params)
  end
  
  describe "#create" do
    before(:each) do
      User.stub!(:authenticate).and_return @user
      @user.stub!(:remember_token)
      @user.stub!(:remember_token_expires_at)
      @user.stub!(:remember_me)
    end
    
    it "should assign the current user on a successful login" do
      User.should_receive(:authenticate).and_return(@user)
      dispatch_to(Session, :create, @params).assigns(:current_user).should == @user
    end
    
    it "should use the email and password parameter to authenticate" do
      User.should_receive(:authenticate).with(@params[:email], @params[:password])
      
      dispatch_to(Session, :create, @params)
    end
    
    it "should use an empty string if the email parameter is not supplied" do
      User.should_receive(:authenticate).with("", @params[:password])
      
      dispatch_to(Session, :create, @params.except(:email))
    end
    
    it "should use an empty string if the password parameter is not supplied" do
      User.should_receive(:authenticate).with(@params[:email], "")
      
      dispatch_to(Session, :create, @params.except(:password))
    end
    
    it "should render the 'new' template if the login was unsuccessful" do
      User.should_receive(:authenticate).and_return :false
      
      dispatch_to(Session, :create, @params) do
        self.should_receive(:render).with(:new)
      end
    end
    
    it "should only set the user to be remembered if the :remember_me parameter is 1" do
      @user.should_receive(:remember_me)
      
      dispatch_to(Session, :create, @params.merge(:remember_me => 1))
      
      @user.should_not_receive(:remember_me)
      
      dispatch_to(Session, :create, @params.merge(:remeber_me => 0))
    end
    
    it "should only set the auth_token in the user's cookie if the :remember_me parameter is 1" do
      dispatch_to(Session, :create, @params.merge(:remember_me => 1)) do
        cookies.should_receive(:[]=).and_return do |(key, value)|
          key.should == :auth_token
        end
      end
      
      dispatch_to(Session, :create, @params.merge(:remember_me => false)) do
        #Not sure this allows for non :auth_token assigns
        cookies.should_not_receive(:[]=).with(:auth_token)
      end
    end
    
    it "should redirect on a successful login" do
      @controller = dispatch_to(Session, :create, @params) do
        self.should_receive(:logged_in?).and_return true
      end
            
      @controller.should be_redirected
    end
  end
  
  describe "#destroy" do
    it "should only forget the user if they are logged in" do
      user = @user
      user.should_receive(:forget_me)
      
      dispatch_to(Session, :destroy) do
        self.stub!(:current_user).and_return user
        self.should_receive(:logged_in?).and_return true
      end
      
      user.should_not_receive(:forget_me)
      
      dispatch_to(Session, :destroy) do
        self.should_receive(:logged_in?).and_return false
      end
    end
    
    it "should delete the user's auth_token from thier cookies regardless of their login status" do
      user = @user
      user.stub!(:forget_me)
      
      dispatch_to(Session, :destroy) do
        self.stub!(:current_user).and_return user
        
        self.should_receive(:logged_in?).and_return true
        cookies.should_receive(:delete).with(:auth_token)
      end
      
      dispatch_to(Session, :destroy) do        
        self.should_receive(:logged_in?).and_return false
        cookies.should_receive(:delete).with(:auth_token)
      end
    end
    
    it "should reset the session regardless of the user's login status" do
      user = @user
      user.stub!(:forget_me)
      
      dispatch_to(Session, :destroy) do
        self.stub!(:current_user).and_return user
        
        self.should_receive(:logged_in?).and_return true
        self.should_receive(:reset_session)
      end
      
      dispatch_to(Session, :destroy) do        
        self.should_receive(:logged_in?).and_return false
        self.should_receive(:reset_session)
      end
    end
    
    it "should redirect the user regardless of their login status" do
      user = @user
      user.stub!(:forget_me)
      
      @controller = dispatch_to(Session, :destroy) do
        self.stub!(:current_user).and_return user
        
        self.should_receive(:logged_in?).and_return true
      end
      
      @controller.should be_redirected
      
      @controller = dispatch_to(Session, :destroy) do
        self.stub!(:current_user).and_return user
        
        self.should_receive(:logged_in?).and_return false
      end
      
      @controller.should be_redirected
    end
  end
  
  describe "'s routes" do
    it "should map url(:login) to '/login'" do
      url(:login).should == "/login"
    end
    
    it "should route GET '/login' to Session#login" do
      with_route("/login", "GET") do |params|
        params[:controller].should == "Session" 
        params[:action].should     == "new"
      end
    end
    
    it "should route POST '/login' to Session#create" do
      with_route("/login", "POST") do |params|
        params[:controller].should == "Session" 
        params[:action].should     == "create"
      end
    end
    
    it "should map url(:logout) to '/logout'" do
      url(:logout).should == "/logout"
    end
    
    it "should route '/logout' to Session#logout" do
      with_route("/logout", "GET") do |params|
        params[:controller].should == "Session" 
        params[:action].should     == "destroy"
      end
    end
  end
end