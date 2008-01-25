module AuthenticatedSystem
  protected

  # check if user is logged in
  def logged_in?
    current_user
  end

  # Accesses the current user from the session.
  def current_user
    @current_user ||= session[:user] ? User.find_by_id(session[:user]) : nil
  end

  # Store the given user in the session.
  def current_user=(new_user)
    session[:user] = new_user.nil? ? nil : new_user.id
    @current_user = new_user
  end

  # Check if the user is authorized.
  def authorized?(user)
    return true
  end

  # Filter method to enforce a login requirement.
  def login_required
    return true if logged_in? and authorized?(current_user)
    store_location
    access_denied and return false
  end

  # Redirect as appropriate when an access request fails.
  def access_denied
    redirect '/account/login'
  end  

  # Store the URI of the current request in the session.
  def store_location
    session[:return_to] = request.uri
  end

  # Redirect to the saved URI or default
  def redirect_back_or_default(default)
    redirect(session[:return_to] || default)
    session[:return_to] = nil
  end

end