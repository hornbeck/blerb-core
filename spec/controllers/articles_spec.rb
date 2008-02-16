require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Articles do
  include DefaultSpecHelper
  include ArticleSpecHelper 
  include DefaultControllerHelper

  it_should_behave_like "default controller behavior"

  describe "#index" do
    it "should find all articles and place them in @articles" do
      Article.should_receive(:all).and_return []
      debugger
      dispatch_to(Articles, :index).assigns(:articles).should == []
    end
    
    it "should find all articles by reverse date" do
      Article.should_receive(:all).with(:order => 'created_at desc')
      
      dispatch_to(Articles, :index)
    end
  end
  
  describe "#show" do
    before(:each) do
      @article = mock_model Article,
        {
          :title => "Merb + Blerb = Superb!",
          :slug => "merb-blerb-superb",
          :created_at => Time.now,
          :body => "",
          :comments => []
        }
    end
    
    it "should find the first article by the slug" do
      Article.should_receive(:with_slug).with(@article.slug).and_return @article
      
      dispatch_to(Articles, :show, :id => @article.slug)
    end
    
    it "should find the first article and place it in @article" do
      Article.should_receive(:with_slug).and_return @article
      
      dispatch_to(Articles, :show, :id => @article.slug).assigns(:article).should == @article
    end
    
    it "should raise a NotFound error if the slug id does not find an article" do
      Article.should_receive(:with_slug).and_return nil
      
      lambda { dispatch_to(Articles, :show, :id => @article.slug) }.should raise_error(Merb::ControllerExceptions::NotFound)
    end
  end
end
