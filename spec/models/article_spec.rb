require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Article do
  include DefaultSpecHelper
  include DefaultModelHelper
  include ArticleSpecHelper
  
  it_should_behave_like "validates required fields"
  
  it "should build a slug" do
    article = Article.new(:title => "Page One")
    article.should be_valid
    article.slug.should == "page-one"
  end
  
end