require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "default layout" do
  attr_reader :title, :body
  before(:each) do
    @title = "This is your brain on blerb"
    @body = fake_render 'layout/application.html.erb'
  end

  describe "header" do
    it "should set the title" do
      body.should include("<title>#{title}</title>")
    end
    
    # TODO: jw - change these to either hpricot, or some smarter matcher that doesn't require an exact semantic match
    it "should include the master.css stylesheet" do
      body.should match(/<link.*type=\"text\/css\" href=\"\/stylesheets\/master.css\"/)
    end
    
    it "should include the jquery javascript library" do
      body.should match(/script type=\"text\/javascript\" src=\"\/javascripts\/jquery.js\"/)
    end
  end
end