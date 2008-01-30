class Users < Application
  provides :xml
  
  skip_before :login_required
  
  def new(user = {})
    only_provides :html
    @user = User.new(user)
    render @user
  end
  
  def create(user)
    cookies.delete :auth_token
    
    @user = User.new(user)
    if @user.save
      redirect_back_or_default('/')
    else
      render :action => :new
    end
  end
  
  def activate(activation_code)
    self.current_user = User.find_activated_authenticated_model(activation_code)
    if logged_in? && !current_user.active?
      current_user.activate
    end
    redirect_back_or_default('/')
  end
end