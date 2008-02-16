module ArticleSpecHelper

  def controller_class
    Articles
  end

  def model_class
    Article
  end
  
  def valid_attributes
    {
      :title => "Blog Post #{rand(50)} on #{Time.now.to_i}",
      :body => "like omgwtfbbq!",
      :slug => "omgimaslug"
    }
  end

  def mock_attributes
    {
      :title => "a title",
      :body => "body text",
      :created_at => Time.now
    }
  end
  
  def updated_attributes
    {:title => 'Another worthy blog post'}
  end

  def required_fields
    [:title]
  end

end
