require File.join(File.dirname(__FILE__), 'route_spec_helper')
require 'ruby-debug'

describe "The comments resource" do
  
  it "should map url(:edit_comment, @comment) to '/admin/comments/<comment_id>'" do
    @comment = mock_model(Comment)
    
    url(:edit_comment, @comment).should == "/admin/comments/#{@comment.id}"
  end
    
  it "should map url(:delete_comment, @comment) to '/admin/comments/<comment_id>/delete'" do
    @comment = mock_model(Comment)
    
    url(:delete_comment, @comment).should == "/admin/comments/#{@comment.id}/delete"
  end
  
  it "should map url(:approve_comment, @comment) to '/admin/comments/<comment_id>/approve'" do
    @comment = mock_model(Comment)
    
    url(:approve_comment, @comment).should == "/admin/comments/#{@comment.id}/approve"
  end
  
  it "should map url(:reject_comment, @comment) to '/admin/comments/<comment_id>/reject'" do
    @comment = mock_model(Comment)
    
    url(:reject_comment, @comment).should == "/admin/comments/#{@comment.id}/reject"
  end
  
  it "should map url(:new_comment, @article) to '/articles/<article_id>/comments/new" do
    @article = mock_model(Article)
    
    url(:new_comment, @article).should == "/articles/#{@article.id}/comments/new"
  end
  
  it "should map url(:comments) ot '/admin/comments'" do
    url(:comments).should == "/admin/comments"
  end
  
  it "should route GET '/admin/comments/123' to Comments#edit with {:id => '123'}" do
    request_to("/admin/comments/123").should route_to(Admin::Comments, :edit).with(:id => '123')
  end
  
  it "should route POST '/admin/comments/123' to Admin::Comments#update with {:id => '123'}" do
    request_to("/admin/comments/123", :post).should route_to(Admin::Comments, :update).with(:id => '123')
  end
  
  it "should route POST '/admin/comments/123/delete' to Admin::Comments#destroy with {:id => '123'}" do
    request_to("/admin/comments/123/delete", :post).should route_to(Admin::Comments, :destroy).with(:id => '123')
  end
  
  it "should route GET '/admin/comments' to Admin::Comments#index" do
    request_to("/admin/comments").should route_to(Admin::Comments, :index)
  end
end