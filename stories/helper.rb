require 'rubygems'
require 'spec/rake/spectask'
require File.join(File.dirname(__FILE__), "..", "spec", "spec_helper")
require 'spec/mocks'
require 'spec/story'

require 'merb_stories'

Dir[File.dirname(__FILE__) + "/helpers/*_helper.rb"].uniq.each { |file| require file }

class MerbStory
  include BoxyStories
end

Dir['stories/steps/**/*.rb'].each do |steps_file|
  require steps_file
end