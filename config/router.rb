puts "Compiling routes.."
Merb::Router.prepare do |r|

  r.namespace('admin') do |admin|

    admin.to(:controller => "users") do |admin_users|
      admin_users.match('/users/new', :method => :post).to(:action => 'create').name(:create_user)
      admin_users.match('/users/new').to(:action => 'new').name(:new_user)
      admin_users.match('/users/:id', :method => :delete).to(:action => 'destroy')
      admin_users.match('/users/:id/delete').to(:action => 'delete').name(:delete_user)
      admin_users.match('/users/:id/edit').to(:action => 'edit').name(:edit_user)
      admin_users.match('/users/:id', :method => :put).to(:action => 'update').name(:update_user)
      admin_users.match('/users/:id').to(:action => 'show').name(:user)
      admin_users.match('/users').to(:action => 'index').name(:users)
      admin_users.match('/users', :method => :post).to(:action => 'create')
    end

    admin.to(:controller => "settings") do |admin_settings|
      admin_settings.match('/settings', :method => :put).to(:action => 'update').name(:update_settings)
      admin_settings.match('/settings').to(:action => 'edit').name(:edit_settings)
    end

    admin.to(:controller => "comments") do |admin_comments|
      admin_comments.match('/comments/delete', :method => :post).to(:action => "destroy_multiple").name(:delete_comments)
      admin_comments.match('/comments/:id/reject', :method => :post).to(:action => "reject").name(:reject_comment)
      admin_comments.match('/comments/:id/approve', :method => :post).to(:action => "approve").name(:approve_comment)
      admin_comments.match('/comments/:id/delete', :method => :post).to(:action => "destroy").name(:delete_comment)
      admin_comments.match('/comments/:id', :method => :post).to(:action => "update").name(:update_comment)
      admin_comments.match('/comments/:id').to(:action => "edit").name(:edit_comment)
      admin_comments.match('/comments').to(:action => "index").name(:comments)
    end

    admin.to(:controller => "articles") do |admin_articles|
      admin_articles.match('/articles/new', :method => :post).to(:action => "create").name(:create_article)
      admin_articles.match('/articles/new').to(:action => "new").name(:new_article)
      admin_articles.match('/articles/:id/delete', :method => :delete).to(:action => "destroy")
      admin_articles.match('/articles/:id/delete', :method => :post).to(:action => "destroy").name(:delete_article)
      admin_articles.match('/articles/:id/edit').to(:action => "edit").name(:edit_article)
      admin_articles.match('/articles/:id', :method => :put).to(:action => "update").name(:update_article)
      admin_articles.match('/articles/:id').to(:action => "show").name(:review_article)
      admin_articles.match('/articles').to(:action => "index").name(:review_articles)
    end
  end

  r.to(:controller => "session") do |session|
    session.match("/login", :method => :post).to(:action => 'create')
    session.match("/login").to(:action => "new").name(:login)
    session.match("/logout").to(:action => "destroy").name(:logout)
  end

  r.to(:controller => "users") do |users|
    users.match("/users/activate/:activation_code").to(:action => 'activate').name(:user_activation)
  end

  r.to(:controller => "comments") do |comments|
    comments.match('/articles/:id/comments/new', :method => :post).to(:action => "create").name(:new_comment)
  end

  r.to(:controller => "articles") do |articles|
    articles.match('/articles/:id').to(:action => "show").name(:article)
    articles.match('/articles').to(:action => "index").name(:articles)
  end

  r.match('/admin').to(:namespace => "admin", :controller => "articles", :action => "index").name(:admin_home)
  r.match('/').to(:controller => 'articles').name(:home)
end
