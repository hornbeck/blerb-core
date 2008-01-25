require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "/articles" do
  before(:each) do
    @article1 = mock("article")
    @article2 = mock("article")
    @article1.should_receive(:title).and_return("Article 1")
    @article2.should_receive(:title).and_return("Article 2")    
    Article.stub!(:all).and_return([@article1,@article2])

    @body = fake_render 'articles/index.html.erb', :articles => Article.all
  end

  it "should mention Articles" do
    @body.should match(/Articles/)
  end
  
  it "should have page title in h1" do
    @body.should include("<h1>Listing Articles</h1>")  
  end
  
  it "should list all articles" do
    @body.should include("<li>Article 1</li>")
    @body.should include("<li>Article 2</li>")
  end
end