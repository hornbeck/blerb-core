puts "Compiling routes.."
Merb::Router.prepare do |r|
  # RESTful routes
  r.resources :articles do |post|
    post.resources :comments
  end
  
  r.match("/signup").to(:controller => "users", :action => "new").name(:signup)
  r.to(:controller => "Session") do |session|
    session.match("/login").to(:action => "create").name(:login)
    session.match("/logout").to(:action => "destroy").name(:logout)
  end
  r.match("/users/activate/:activation_code").to(:controller => "Users", :action => "activate").name(:user_activation)
  r.resources :users
  
  r.default_routes
  
  # Set the default to articles for now
  r.match('/').to(:controller => 'articles', :action =>'index')
end
