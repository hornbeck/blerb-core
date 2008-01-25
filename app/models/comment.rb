class Comment < DataMapper::Base
  
  property :email, :string, :lazy => false
  property :body, :text, :lazy => false
  property :article_id, :integer
  
  belongs_to :article
  
  validates_presence_of :post_id, :email
end

