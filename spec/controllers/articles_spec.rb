require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Articles do
  include DefaultSpecHelper
  include DefaultControllerHelper
  include ArticleSpecHelper

  it_should_behave_like "default controller behavior"
  
  describe "#index" do
    it "should return a list of all articles in reverse order of creation" do
      created_articles = []
      4.times do |counter|
        new_article = Article.create(:title => "post #{counter}")
        new_article.created_at = Time.now - rand(5000000)
        new_article.save
        created_articles << new_article
      end
      expected_ids = created_articles.sort_by(&:created_at).reverse.collect(&:id)

      do_index
    
      controller.assigns(:articles).collect(&:id).should == expected_ids
      controller.should be_successful
    end
    
  end
end
