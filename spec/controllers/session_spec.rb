require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
require File.join( File.dirname(__FILE__), "..", "user_spec_helper")
require File.join( File.dirname(__FILE__), "..", "authenticated_system_spec_helper")
require 'cgi'

describe "Sessions Controller", "index action" do
  include UserSpecHelper
  
  before(:each) do
    User.clear_database_table
    @quentin = User.create(valid_user_hash.with(:email => "quentin@example.com", :password => "test", :password_confirmation => "test"))
    @controller = Session.new(fake_request)
    @quentin.activate
  end
  
  it "should have a route to Session#new from '/login'" do
    with_route("/login") do |params|
      params[:controller].should == "Session"
      params[:action].should == "new"
    end   
  end
  
  it "should have a named route :login" do
    controller.url(:login).should == "/login"
  end
  
  it "should have route to Session#destroy from '/logout' via delete" do
    with_route("/logout", "DELETE") do |params|
      params[:controller].should == "Session"
      params[:action].should    == "destroy"
    end   
  end
  
  it "should route to Session#destroy from '/logout' via get" do
    with_route("/logout", "GET") do |params|
      params[:controller].should == "Session" 
      params[:action].should     == "destroy"
    end
  end

  it 'logins and redirects' do
    post "/session", :email => 'quentin@example.com', :password => 'test'
    session[:user].should_not be_nil
    session[:user].should == @quentin.id
    controller.should redirect_to("/")
  end
   
  it 'fails login and does not redirect' do
    post "/session", :email => 'quentin@example.com', :password => 'bad password'
    session[:user].should be_nil
    controller.template.should match(/^new\./)
    controller.should be_success
  end

  it 'logs out' do
    get("/logout"){|response| response.stub!(:current_user).and_return(@quentin) }
    session[:user].should be_nil
    controller.should redirect
  end

  it 'remembers me' do
    post "/session", :email => 'quentin@example.com', :password => 'test', :remember_me => "1"
    cookies["auth_token"].should_not be_nil
  end
 
  it 'does not remember me' do
    post "/session", :email => 'quentin@example.com', :password => 'test', :remember_me => "0"
    cookies["auth_token"].should be_nil
  end
  
  it 'deletes token on logout' do
    get("/logout") {|request| request.stub!(:current_user).and_return(@quentin) }
    cookies["auth_token"].should == nil
  end
  
  
  it 'logs in with cookie' do
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