require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Articles Controller", "index action" do
  before(:each) do
    @article1 = mock("article")
    @article2 = mock("article")
    @articles = [@article1, @article2]
    Article.should_receive(:all).and_return(@articles)
    @controller = Articles.build(fake_request)
    @controller.stub!(:render)
    @controller.dispatch('index')
  end
  
  it "should get successfully" do
    @controller.status.should == 200
  end
  
  it "should assign all articles" do
    @controller.instance_variable_get("@articles").should == @articles
  end
end

describe "Articles Controller", "show action" do
  before(:each) do 
    @article = mock("@article")
    @article.stub!(:id).and_return(1)
    Article.stub!(:find_by_id).and_return(@article)
  end
  
  it "should return only one article" do 
    Article.should_receive(:find).with('1').and_return(@article)
    request(:get, '/articles/1', :yields => controller)
  end
  
  it "should only return comments associated with this article"
  
end

describe "Articles Controller", "destroy action" do
  
  it "should only delete one article"
  it "should delete all comments owned by the deleted article"
  
end

