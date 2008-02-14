module Permalinker

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    def permalinker(source)
      include InstanceMethods
      class_eval do
        extend SingletonMethods
        property :slug, :string, :lazy => false
        validates_presence_of :slug
        validates_uniqueness_of :slug
        before_validation { |record| record.set_identifier!(source) }
      end
    end
  end
  
  # Adds class methods.
  module SingletonMethods
    def format_identifier(s)
      s.gsub!(/'/,'') # remove characters that occur mid-word
      s.gsub!(/[\W]/,' ') # translate non-words into spaces
      s.strip! # remove spaces from the ends
      s.gsub!(/\ +/,'-') # replace spaces with hyphens
      s.downcase # lowercase what's left
    end
    
    def with_slug(slug)
      first :slug => slug
    end
  end

  # Adds instance methods.
  module InstanceMethods
    def set_identifier!(source)
      source_column = source.to_s
      identifier_column = "slug"
      if self.send(source_column)
        self.slug = self.class.format_identifier(self.send(source_column).to_s.dup)
      end
    end
    
    def to_param
      self.slug
    end
  end
end