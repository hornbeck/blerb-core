require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Comments do
  before(:each) do
    @article = mock_model Article,
      {
        :title => "Merb + Blerb = Superb!",
        :slug => "merb-blerb-superb",
        :created_at => Time.now,
        :body => ""
      }
    
    @comment = mock_model(Comment)
  end
  
  describe "#create" do
    it "should find the article for the new comment by the article id" do
      #Stubs & mocks, stubs & mocks
      builder = mock(:dm_builder)
      builder.stub!(:build).and_return @comment
      @comment.stub!(:request=)
      @comment.stub!(:save)
      @article.stub!(:comments).and_return(builder)
      
      #The good stuff
      Article.should_receive(:first).and_return @article
      
      dispatch_to(Comments, :create, :article_id => @article.id, :comment => "T-T-T-Testing!")
    end
    
    it "should be able to create a comment"
    it "should redirect to parent article if create succeeds"
    it "should redirect to parent ar new again if authentication failed"
  end
end