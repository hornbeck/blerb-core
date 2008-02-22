# Encapsulates settings for blerb.
class Setting
  SETTINGS_PATH = 'config/settings.yml'
  DEFAULT_SETTINGS_PATH = 'config/settings.default.yml'
  
  attr_accessor :attributes
  
  class << self
    # Gets an instance of +Setting+. It will attempt to use +SETTINGS_PATH+ if it exists,
    # or fall back on +DEFAULT_SETTINGS_PATH+.
    def instance
      if File.exists? SETTINGS_PATH
        load SETTINGS_PATH
      else
        load DEFAULT_SETTINGS_PATH
      end
    end
    
    # Loads a +Setting+ using +path+.
    def load path
      file = File.open(path, 'r')
      Setting.new(YAML::load(file))
    end
  end
  
  def initialize(attrs)
    @attributes = attrs
  end
  
  def title
    @title ||= @attributes['settings']['title']
  end
  
  def title=(str)
    @attributes['settings']['title'] = str
  end
  
  def tagline
    @tagline ||= @attributes['settings']['tagline']
  end
  
  def tagline=(str)
    @attributes['settings']['tagline'] = str
  end
  
  def save
    File.open(SETTINGS_PATH, 'w') do |f|
      f.puts @attributes.to_yaml
      f.close
    end
  end
  
end