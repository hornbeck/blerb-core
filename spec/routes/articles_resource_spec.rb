require File.join(File.dirname(__FILE__), 'route_spec_helper')

describe "The articles resource" do
  it "should map url(:article, @article) to '/articles/<article_id>" do
    @article = mock_model(Article)
    
    url(:article, @article).should == "/articles/#{@article.id}"
  end
  
  it "should map url(:edit_article, @article) to '/admin/articles/<article_id>/edit" do
    @article = mock_model(Article)
    
    url(:edit_article, @article).should == "/admin/articles/#{@article.id}/edit"
  end
  
  it "should map url(:delete_article, @article) to '/admin/articles/<article_id>/delete" do
    @article = mock_model(Article)
    
    url(:delete_article, @article).should == "/admin/articles/#{@article.id}/delete"
  end
  
  it "should map url(:new_article, @article) to '/admin/articles/new'" do
    url(:new_article, @article).should == "/admin/articles/new"
  end
  
  it "should map url(:new_article, @article) to '/admin/articles/new'" do
    url(:create_article, @article).should == "/admin/articles/new"
  end
  
  it "should route GET '/articles/123' to Articles#show with {:id => '123'}" do
    request_to("/articles/123").should route_to(Articles, :show).with(:id => '123')
  end
  
  it "should route GET '/admin/articles/123/edit' to Admin::Articles#edit with {:id => '123'}" do
    request_to("/admin/articles/123/edit").should route_to(Admin::Articles, :edit).with(:id => '123')
  end
  
  it "should route PUT '/admin/articles/123' to Admin::Articles#update with {:id => '123'}" do
    request_to("/admin/articles/123", :put).should route_to(Admin::Articles, :update).with(:id => '123')
  end
  
  it "should route GET '/admin/articles/new' to Admin::Articles#new" do
    request_to("/admin/articles/new").should route_to(Admin::Articles, :new)
  end
  
  it "should route POST '/admin/articles/new' to Admin::Articles#create" do
    request_to("/admin/articles/new", :post).should route_to(Admin::Articles, :create)
  end
end