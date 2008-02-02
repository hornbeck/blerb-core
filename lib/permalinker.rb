module Permalinker
  mattr_accessor :identifier_options

  def self.included(base)
    base.send(:extend,ClassMethods)
  end

  module ClassMethods
    def permalinker(source, options = {})
      class_inheritable_accessor :identifier_options
      self.identifier_options = {
        :keep_updated => true,
        :identifier_column => :slug
      }.merge(options)
      include InstanceMethods
      class_eval{ extend SingletonMethods}
      validates_presence_of identifier_options[:identifier_column]
      validates_uniqueness_of identifier_options[:identifier_column],
                              :scope => (identifier_options[:scope])
      before_validation { |record| record.set_identifier!(source) }
    end
  end
  
  # Adds class methods.
  module SingletonMethods 
    def find(*args)
      if args.first.is_a? String
        super(:first, :conditions => ["#{identifier_options[:identifier_column]} = ?", args.first])
      else
        super
      end
    end
    
    def format_identifier(s)
      s.gsub!(/'/,'') # remove characters that occur mid-word
      s.gsub!(/[\W]/,' ') # translate non-words into spaces
      s.strip! # remove spaces from the ends
      s.gsub!(/\ +/,'-') # replace spaces with hyphens
      s.downcase # lowercase what's left
    end 
  end

  # Adds instance methods.
  module InstanceMethods
    def set_identifier!(source)
      source_column = source.to_s
      identifier_column = identifier_options[:identifier_column].to_s
      if identifier_options[:keep_updated] or self[identifier_column].blank?
        if self[source_column]
          self[identifier_column] = self.class.format_identifier(self[source_column].to_s.dup)
        end
      end
    end
  end
end