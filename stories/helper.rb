require 'rubygems'
require 'spec/rake/spectask'
require File.join(File.dirname(__FILE__), "..", "spec", "spec_helper")
require 'spec/mocks'
require 'spec/story'

Dir[File.dirname(__FILE__) + "/helpers/*_helper.rb"].uniq.each { |file| require file }

class MerbStory
  include Merb::Test::Rspec::ControllerMatchers
  # TODO: update boxy steps to use merb's markup matchers
  include Merb::Test::Rspec::MarkupMatchers
  include BoxyStories
  
  def url(name, params={})
    Merb::Router.generate(name, params)
  end
end

Dir['stories/steps/**/*.rb'].each do |steps_file|
  require steps_file
end