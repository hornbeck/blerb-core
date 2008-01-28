require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Article do
  include DefaultSpecHelper
  include DefaultModelHelper
  include ArticleSpecHelper

  it_should_behave_like "timestamps work correctly"
  it_should_behave_like "validates required fields"
  
  it "should build a slug" do
    article = Article.new(:title => "Page One")
    article.save
    article.should_not be_nil
    article.slug.should == "Page_One"
  end
  
end