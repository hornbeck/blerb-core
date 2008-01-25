require File.join( File.dirname(__FILE__), "..", "spec_helper" )

module CommentSpecHelper
  
  def valid_page_attributes
    {:email => "hornbeck@gmail.com", :body => "This is a body"}
  end
  
end

describe Comment do
  include CommentSpecHelper
  
  before(:each) do 
    @article = Article.new
    @comment = Comment.new
  end
  
  it "should belong to a article" do 
    @comment.article = @article
    @comment.article.id.should == @article.id
  end
  
  it "should require a article" do 
    @comment.attributes = valid_page_attributes.except(:article_id)
    @comment.should_not be_valid
  end
  
  it "should have an email" do 
    @comment.email = "hornbeck@gmail.com"
    @comment.email.should == "hornbeck@gmail.com"
  end

end