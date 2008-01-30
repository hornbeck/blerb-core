require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "index.html.erb" do
#  describe "when articles exist" do
#    attr_reader :titles, :body, :header
#    before(:each) do
#      @header = "Latest Articles"
#      @titles = ["Good Article", "Even Better Article"]
#      
#      article1 = mock("article")
#      article2 = mock("article")
#      article1.should_receive(:title).and_return(titles[0])
#      article2.should_receive(:title).and_return(titles[1])    
#      Article.stub!(:all).and_return([article1,article2])
#
#      @body = fake_render 'articles/index.html.erb', :articles => Article.all
#    end
#
#    it "should mention Articles" do
#      body.should match(/Articles/)
#    end
#  
#    it "should have page title in h1" do
#      body.should include("<h1>#{header}</h1>")  
#    end
#  
#    it "should list all articles" do
#      titles.each { |title|
#        body.should include("<h2>#{title}</h2>")
#      }
#    end
#  end
#
#  describe "when no articles have been created" do
#    attr_reader :body, :no_articles_text
#    before(:each) do
#      @no_articles_text = "No articles created yet"
#      @body = fake_render 'articles/index.html.erb', :articles => []
#    end
#
#    it "should mention no articles have been created" do
#      body.should include("<h2>#{no_articles_text}</h2>")  
#    end
#  end
end