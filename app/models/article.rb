class Article < DataMapper::Base
  property :title, :string, :lazy => false
  property :body, :text, :lazy => false
  property :slug, :string, :lazy => false
  
  property :created_at, :datetime
  property :updated_at, :datetime

  has_many :comments
  
  before_save :set_slug
  
  def set_slug(slug = self.title)
    self.slug = slug.gsub(" ", "_")
  end
  
end

