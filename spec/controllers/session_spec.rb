require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
require File.join( File.dirname(__FILE__), "..", "user_spec_helper")
require File.join( File.dirname(__FILE__), "..", "authenticated_system_spec_helper")
require 'cgi'

describe Session, "index action" do
  include UserSpecHelper
  
  before(:each) do
    User.clear_database_table
    @quentin = User.create(valid_user_hash.with(:email => "quentin@example.com", :password => "test", :password_confirmation => "test"))
    # @controller = Session.new(fake_request)
    @quentin.activate
  end
  
  it "should have a route to Session#new from '/login'" do
    pending
    get '/login'
    @controller.params[:controller].should == "Session"
    @controller.params[:action].should == "new"
  end
  
  it "should have a named route :login" do
    pending
    controller.url(:login).should == "/login"
  end
  
  it "should have route to Session#destroy from '/logout' via delete" do
    pending
    with_route("/logout", "DELETE") do |params|
      params[:controller].should == "Session"
      params[:action].should    == "destroy"
    end   
  end
  
  it "should route to Session#destroy from '/logout' via get" do
    pending
    with_route("/logout", "GET") do |params|
      params[:controller].should == "Session" 
      params[:action].should     == "destroy"
    end
  end

  it 'fails login and does not redirect' do
    pending
    controller = dispatch_to(Session, :email => 'quentin@example.com', :password => 'bad password')
    session[:user].should be_nil
    controller.template.should match(/^new\./)
    controller.should be_success
  end

  it 'logs out' do
    pending
    get("/logout"){|response| response.stub!(:current_user).and_return(@quentin) }
    session[:user].should be_nil
    controller.should redirect
  end

  it 'remembers me' do
    pending
    post "/session", :email => 'quentin@example.com', :password => 'test', :remember_me => "1"
    cookies["auth_token"].should_not be_nil
  end
 
  it 'does not remember me' do
    pending
    post "/session", :email => 'quentin@example.com', :password => 'test', :remember_me => "0"
    cookies["auth_token"].should be_nil
  end
  
  it 'deletes token on logout' do
    pending
    get("/logout") {|request| request.stub!(:current_user).and_return(@quentin) }
    cookies["auth_token"].should == nil
  end
  
  
  it 'logs in with cookie' do
    pending
    @quentin.remember_me
    get "/login" do |request|
      request.env[Merb::Const::HTTP_COOKIE] = "auth_token=#{@quentin.remember_token}"
    end
    controller.should be_logged_in
  end

  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
    
  def cookie_for(user)
    auth_token user.remember_token
  end
end

describe Session, "logging in successfully" do
  # include Merb::Test::Rspec::ControllerMatchers
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
  
  def do_it
    @controller = dispatch_to(Session, :create, :email => 'quentin@example.com', :password => 'test')
  end
end