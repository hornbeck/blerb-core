puts "Compiling routes.."
Merb::Router.prepare do |r|
  # RESTful routes
  r.resources :articles do |post|
    post.resources :comments
  end

  r.resources :articles, :namespace => 'admin'
  r.resources :comments, :namespace => 'admin'
  r.match("/admin/comments/reject/:id", :method => :put).to(:controller => "admin/comments",:action => "reject").name(:reject_admin_comment)
  r.match("/admin/comments/approve/:id", :method => :put).to(:controller => "admin/comments",:action => "approve").name(:approve_admin_comment)
    r.match("/admin/comments/destroy_multiple", :method => :delete).to(:controller => "admin/comments",:action => "destory_multiple").name(:destroy_multiple_admin_comments)
  r.resources :users, :namespace => 'admin'
  r.match("/admin").to(:controller => "admin/articles", :action => 'index').name(:admin_home)
  
  r.match("/signup").to(:controller => "users", :action => "new").name(:signup)
  r.to(:controller => "Session") do |session|
    session.match("/login").to(:action => "new").name(:login)
    session.match("/logout").to(:action => "destroy").name(:logout)
  end
  r.match("/users/activate/:activation_code").to(:controller => "Users", :action => "activate").name(:user_activation)
  r.resources :users
  r.resource :session
  
  #r.default_routes
  
  # Set the default to articles for now
  r.match('/').to(:controller => 'articles', :action =>'index').name(:home)
end
