class Setting
  
  attr_accessor :attributes
  
  class << self
    def load
      @file = File.open("config/settings.yml","r")
      Setting.new(YAML::load(@file))
    end
  end
  
  def initialize(attrs)
    @attributes = attrs
  end
  
  def title
    @title ||= @attributes["settings"]["title"]
  end
  
  def title=(str)
    @attributes["settings"]["title"] = str
  end
  
  def tagline
    @tagline ||= @attributes["settings"]["tagline"]
  end
  
  def tagline=(str)
    @attributes["settings"]["tagline"] = str
  end
  
  def save
    File.open("config/settings.yml","w") do |f|
      f.puts @attributes.to_yaml
      f.close
    end
  end
  
end