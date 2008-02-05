module Tagging

  def self.included(base)
    base.class_eval do
      has_and_belongs_to_many :tags
    end
    base.send(:extend,ClassMethods)
  end

  module ClassMethods
    def tagging
      include InstanceMethods
      class_eval{ extend SingletonMethods}
    end
  end
  
  # Adds class methods.
  module SingletonMethods 
    def find_tagged_with()
    end
    
  end

  # Adds instance methods.
  module InstanceMethods
    def tag_list
      @tag_list ||= tags.map(&:name).join(", ")
    end
    
    def tag_list=(list)
      tags.clear
      list.split(",").each do |tag|
        tags<< Tag.create(:name => tag.strip)
      end
    end
    
    def add_tag(name)
      tags << Tag.create(:name => name.strip)
    end
    
    def remove_tag(name)
      tags.delete(Tag.first(:name => name.strip))
    end
  end
end