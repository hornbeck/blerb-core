puts "Compiling routes.."
Merb::Router.prepare do |r|
  
  r.resources :users, :namespace => 'admin'
  
  r.namespace('admin') do |admin|
    
    admin.to(:controller => "settings") do |admin_settings|
      admin_settings.match('/admin/settings', :method => :post).to(:action => 'update').name(:update_settings)
      admin_settings.match('/admin/settings').to(:action => 'edit').name(:edit_settings)
    end
    
    admin.to(:controller => "comments") do |admin_comments|
      admin_comments.match('/admin/comments/delete', :method => :post).to(:action => "destroy_multiple").name(:delete_comments)
      admin_comments.match('/admin/comments/:id/reject', :method => :post).to(:action => "reject").name(:reject_comment)
      admin_comments.match('/admin/comments/:id/approve', :method => :post).to(:action => "approve").name(:approve_comment)
      admin_comments.match('/admin/comments/:id/delete', :method => :post).to(:action => "destroy").name(:delete_comment)
      admin_comments.match('/admin/comments/:id', :method => :post).to(:action => "update").name(:update_comment)
      admin_comments.match('/admin/comments/:id').to(:action => "edit").name(:edit_comment)
      admin_comments.match('/admin/comments').to(:action => "index").name(:comments)
    end
    
    admin.to(:controller => "articles") do |admin_articles|
      admin_articles.match('/admin/articles/new', :method => :post).to(:action => "create").name(:create_article)
      admin_articles.match('/admin/articles/new').to(:action => "new").name(:new_article)
      admin_articles.match('/admin/articles/:id/delete', :method => :delete).to(:action => "destroy")
      admin_articles.match('/admin/articles/:id/delete', :method => :post).to(:action => "destroy").name(:delete_article)
      admin_articles.match('/admin/articles/:id/edit').to(:action => "edit").name(:edit_article)
      admin_articles.match('/admin/articles/:id', :method => :put).to(:action => "update").name(:update_article)
      #admin_articles.match('/admin/articles/:id').to(:action => "show").name(:review_article)
      
      admin_articles.match('/admin').to(:action => "index").name(:admin_home)
    end
  end
  
  r.to(:controller => "session") do |session|
    session.match("/login", :method => :post).to(:action => 'create')
    session.match("/login").to(:action => "new").name(:login)
    session.match("/logout").to(:action => "destroy").name(:logout)
  end
  
  r.to(:controller => "users") do |users|
    r.resources :users
    users.match('/signup').to(:action => 'new').name(:signup)
    users.match("/users/activate/:activation_code").to(:action => 'activate').name(:user_activation)
  end
  
  r.to(:controller => "comments") do |comments|
    comments.match('/articles/:id/comments/new', :method => :post).to(:action => "create").name(:new_comment)
  end
  
  r.to(:controller => "articles") do |articles|
    articles.match('/articles/:id').to(:action => "show").name(:article)
  end
  
  r.match('/').to(:controller => 'articles').name(:home)
end
