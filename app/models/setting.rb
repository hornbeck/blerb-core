class Setting
  
  attr_accessor :attributes
  
  class << self
    SETTINGS_PATH = 'config/settings.yml'
    SAMPLE_SETTINGS_PATH = 'config/settings.default.yml'
    
    def instance
      if File.exists? SETTINGS_PATH
        load SETTINGS_PATH
      else
        load SAMPLE_SETTINGS_PATH
      end
    end
    
    def load path
      file = File.open(path, 'r')
      Setting.new(YAML::load(file))
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