module ArticleSpecHelper

  def controller_class
    Articles
  end

  def model_class
    Article
  end
  
  def valid_attributes
    {:title => 'My Bestest Blog Post'}
  end
  
  def updated_attributes
    {:title => 'Another worthy blog post'}
  end

  def required_fields
    [:title]
  end

end
