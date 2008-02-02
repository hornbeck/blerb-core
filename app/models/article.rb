dependency 'permalinker'
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
  has_and_belongs_to_many :tags
  
  validates_presence_of :title
  
end

