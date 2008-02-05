class Tag < DataMapper::Base
  property :name, :string
  
  validates_presence_of :name
  validates_uniqueness_of :name
end

