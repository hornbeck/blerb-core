module AuthenticatedSystem
  module Controller
    protected
      # Returns true or false if the user is logged in.
      # Preloads @current_user with the user model if they're logged in.
      def logged_in?
        current_user != :false
      end
    
      # Accesses the current user from the session.  Set it to :false if login fails
      # so that future calls do not hit the database.
      def current_user
        @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie || :false)
      end
    
      # Store the given user in the session.
      def current_user=(new_user)
        session[:user] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
        @current_user = new_user
      end
    
      def authorized?
        logged_in?
      end

      def login_required
        authorized? || throw(:halt, :access_denied)
      end

      def access_denied
        case content_type
        when :html
          store_location
          redirect url(:login)
        when :xml
          headers["Status"]             = "Unauthorized"
          headers["WWW-Authenticate"]   = %(Basic realm="Web Password")
          set_status(401)
          render :text => "Couldn't authenticate you"
        end
      end
 
      def store_location
        session[:return_to] = request.uri
      end
    

      def redirect_back_or_default(default)
        redirect(session[:return_to] || default)
        session[:return_to] = nil
      end
    
      def login_from_session
        self.current_user = User.find_authenticated_model_with_id(session[:user]) if session[:user]
      end

      # Called from #current_user.  Now, attempt to login by basic authentication information.
      def login_from_basic_auth
        username, passwd = get_auth_data
        self.current_user = User.authenticate(username, passwd) if username && passwd
      end

      # Called from #current_user.  Finaly, attempt to login by an expiring token in the cookie.
      def login_from_cookie     
        user = cookies[:auth_token] && User.find_authenticated_model_with_remember_token(cookies[:auth_token])
        if user && user.remember_token?
          user.remember_me
          cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
          self.current_user = user
        end
      end
    
      def reset_session
        session.data.each{|k,v| session.data.delete(k)}
      end

    private
      @@http_auth_headers = %w(Authorization HTTP_AUTHORIZATION X-HTTP_AUTHORIZATION X_HTTP_AUTHORIZATION REDIRECT_X_HTTP_AUTHORIZATION)

      # gets BASIC auth info
      def get_auth_data
        auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
        auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
        return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil] 
      end
  end
end