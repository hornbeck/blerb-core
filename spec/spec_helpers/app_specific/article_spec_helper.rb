module ArticleSpecHelper

  def controller_class
    Articles
  end

  def model_class
    Article
  end
  
  def valid_attributes
    {:title => "Blog Post #{rand(50)} on #{Time.now.to_i}"}
  end
  
  def updated_attributes
    {:title => 'Another worthy blog post'}
  end

  def required_fields
    [:title]
  end

end
