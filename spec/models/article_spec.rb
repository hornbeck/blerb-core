require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Article do
  before(:each) do 
    @article = Article.new
  end
  
  it "should have a title" do 
    @article.title = "First article!"
    @article.title.should == "First article!"
  end
  
  it "should have a body" do 
    @article.body = "The body of the article"
    @article.body.should == "The body of the article"
  end
  
  it "should build a slug" do
    @article.title = "Page One"
    @article.save
    @article.slug.should == "Page_One"
  end
  
end