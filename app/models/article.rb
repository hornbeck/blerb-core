class Article < DataMapper::Base
  property :title, :string, :lazy => false
  property :body, :text, :lazy => false
  property :slug, :string, :lazy => false
  
  property :created_at, :datetime
  property :updated_at, :datetime

  property :published_at, :datetime
  property :draft, :boolean

  has_many :comments
  belongs_to :user
  
  validates_presence_of :title
  validates_presence_of :slug
  
  before_validation :set_slug
  
  def set_slug(slug_title = self.title)
    self.slug = slug_title.gsub(" ", "_") if slug_title
  end
  
end

