require File.dirname(__FILE__) + '/boxy_helper'
require 'spec'

class Module
  def alias_method_chain(target, feature)
    alias_method "#{target}_without_#{feature}", target
    alias_method target, "#{target}_with_#{feature}"
  end
end

class SpecStory
  include BoxyStories
  
  attr_accessor :response
end

describe SpecStory do
  
  before(:each) do
    @story = SpecStory.new
    @story.response = mock(:html_response)
    @story.response.stub!(:body)
    @match_selector = mock(:match_selector)
    @match_selector.stub!(:matches?).and_return true
  end
  
  it "should call match_selector('//h1#title') when intercepting a message to have_the_h1('title')" do
    @story.should_receive(:match_selector).with("//h1#title").and_return @match_selector
    
    @story.have_the_h1("title")
  end
  
  it "should call match_selector('//h2.subtitle') when intercepting a message to have_a_h2('subtitle')" do
    @story.should_receive(:match_selector).with("//h2.subtitle").and_return @match_selector
    
    @story.have_a_h2("subtitle")
  end
  
  it "should call match_selector('//div#container//h1.title') when intercepting a message to have_a_h1_in_the_box('title', 'container')" do
    @story.should_receive(:match_selector).with("//div#container//h1.title").and_return @match_selector
    
    @story.have_a_h1_in_the_box("title", "container")
  end
  
  it "should call match_selector('//ul.list') when intercepting a message to with_a_ul('list')" do
    @story.should_receive(:match_selector).with("//ul.list").and_return @match_selector
    
    @story.with_a_ul("list")
  end
  
  it "should call match_selector('//a.link[@href=\"path\"]') when intercepting a message to have_a_link_with_path('link', 'path')" do
    @story.should_receive(:match_selector).with("//a.link[@href=\"path\"]").and_return @match_selector
    
    @story.have_a_link_with_path("link", "path")
  end
  
  it "should call match_selector('img.avatar) when intercepting a message to have_an_image('avatar')" do
    @story.should_receive(:match_selector).with("//img.avatar").and_return @match_selector
    
    @story.have_an_image("avatar")
  end
  
  it "should call match_selector('//span.description[@text()~=\"description:\"]') when intercepting a message to have_a_span_with_content('description', /description:/)" do
    @story.should_receive(:match_selector).with("//span.description[@text()~=\"description:\"]").and_return @match_selector
    
    @story.have_a_span_with_content("description", /description:/)
  end
  
  it "should call have_tag('form') when intercepting a message to have_a_form()" do
    @story.should_receive(:match_selector).with("//form").and_return @match_selector
    
    @story.have_a_form
  end
  
  describe "#identifier_and_element" do
    it "should split 'have_an_image' into ['.', 'img']" do
      @story.identifier_and_element('have_an_image').should == ['.', 'img']
    end
    
    it "should split 'have_the_image' into ['#', 'img']" do
      @story.identifier_and_element('have_the_image').should == ['#', 'img']
    end
    
    it "should split 'with_a_span' into ['.', 'span']" do
      @story.identifier_and_element('with_a_span').should == ['.', 'span']
    end
  end
  
  describe "#have_check" do
    
    before(:each) do
      @story.response = mock(:html_response)
      @story.response.stub!(:body)
      @match_selector = mock(:match_selector)
      @match_selector.stub!(:matches?).and_return(true)
    end
    
    it "should call match_selector with \"//div#wrapper\" when called with 'have_the_box', 'wrapper'" do
      @story.should_receive(:match_selector).with("//div#wrapper").and_return @match_selector
      
      @story.have_check("have_the_box", "wrapper")
    end
    
    it "should call match_selector with \"//span.bar\" when called with 'have_a_span', 'bar'" do
      @story.should_receive(:match_selector).with("//span.bar").and_return @match_selector
      
      @story.have_check("have_a_span", "bar")
    end
    
    it "should call match_selector with \"//img.avatar\" when called with 'have_an_image', 'avatar'" do
      @story.should_receive(:match_selector).with("//img.avatar").and_return @match_selector
      
      @story.have_check("have_an_image", "avatar")
    end
    
    it "should raise an error 'html element missing from the response: <div class='content'>' match_selector with \"//img[@class='avatar']\" when called with 'have_a_box', 'content' that fails the match" do
      @match_selector.stub!(:matches?).and_return(false)
      @story.should_receive(:match_selector).with("//div.content").and_return @match_selector
      
      lambda { @story.have_check("have_a_box", "content") }.should raise_error("html element missing from the response: <div class=\"content\">\n\n#{@story.response.body}")
    end
  end
  
  describe "#with_check" do
    before(:each) do
      @story.response = mock(:html_response)
      @story.response.stub!(:body)
      @match_selector = mock(:match_selector)
      @match_selector.stub!(:matches?).and_return(true)
    end
    
    it "should call match_selector with \"//div#wrapper\" when called with 'with_the_box', 'wrapper'" do
      @story.should_receive(:match_selector).with("//div#wrapper").and_return @match_selector
      
      @story.with_check("with_the_box", "wrapper")
    end
    
    it "should call match_selector with \"//span.bar\" when called with 'with_a_span', 'bar'" do
      @story.should_receive(:match_selector).with("//span.bar").and_return @match_selector
      
      @story.have_check("with_a_span", "bar")
    end
    
    it "should call match_selector with \"//img.avatar\" when called with 'with_an_image', 'avatar'" do
      @story.should_receive(:match_selector).with("//img.avatar").and_return @match_selector
      
      @story.have_check("with_an_image", "avatar")
    end
    
    it "should raise an error 'html element missing from the response: <div class='content'>' match_selector with \"//img[@class='avatar']\" when called with 'with_a_box', 'content' that fails the match" do
      @match_selector.stub!(:matches?).and_return(false)
      @story.should_receive(:match_selector).with("//div.content").and_return @match_selector
      
      lambda { @story.with_check("with_a_box", "content") }.should raise_error("html element missing from the response: <div class=\"content\">\n\n#{@story.response.body}")
    end
  end
  
  describe "#have_with_check" do
    before(:each) do
      @story.response = mock(:html_response)
      @story.response.stub!(:body)
      @match_selector = mock(:match_selector)
      @match_selector.stub!(:matches?).and_return(true)
    end
    
    it "should call match_selector with \"//div#wrapper[@align=\"left\"]\" when called with 'have_the_box_with_align', 'wrapper', 'left'" do
      @story.should_receive(:match_selector).with("//div#wrapper[@align=\"left\"]").and_return @match_selector
      
      @story.have_with_check("have_the_box_with_align", "wrapper", "left")
    end
    
    it "should call match_selector with \"//span.bar[@enabled=\"yes\"]\" when called with 'have_a_span_with_enabled', 'bar'" do
      @story.should_receive(:match_selector).with("//span.bar[@enabled=\"yes\"]").and_return @match_selector
      
      @story.have_with_check("have_a_span_with_enabled", "bar", "yes")
    end
    
    it "should call match_selector with \"//img.avatar[@src=\"/images/gravatar.jpg\"]\" when called with 'have_an_image_with_src', 'avatar', '/images/gravatar.jpg'" do
      @story.should_receive(:match_selector).with("//img.avatar[@src=\"/images/gravatar.jpg\"]").and_return @match_selector
      
      @story.have_with_check("have_a_image_with_src", "avatar", "/images/gravatar.jpg")
    end
    
    it "should raise an error 'html element missing from the response: <img class=\"avatar\" src=\"/images/gravatar.jpg\">' match_selector with \"//img.avatar[@src=\"/images/gravatar.jpg\"]\" when called with 'have_an_image_with_src', 'content' that fails the match" do
      @match_selector.stub!(:matches?).and_return(false)
      @story.should_receive(:match_selector).with("//img.avatar[@src=\"/images/gravatar.jpg\"]").and_return @match_selector
      
      lambda { @story.have_with_check("have_a_image_with_src", "avatar", "/images/gravatar.jpg") }.should raise_error("html element missing from the response: <img class=\"avatar\" src=\"/images/gravatar.jpg\">\n\n#{@story.response.body}")
    end
  end
  
  describe "#multi_check" do
    before(:each) do
      @story.response = mock(:html_response)
      @story.response.stub!(:body)
      @match_selector = mock(:match_selector)
      @match_selector.stub!(:matches?).and_return(true)
    end
    
    it "should call match_selector with \"//div#wrapper//p#main\" when called with 'have_the_paragraph_in_the_box', 'wrapper', 'main'" do
      @story.should_receive(:match_selector).with("//div#wrapper//p#main").and_return @match_selector
      
      @story.multi_check("have_the_paragraph_in_the_box", "main", "wrapper")
    end
    
    it "should call match_selector with \"//span.foo//span.bar\" when called with 'have_a_span_in_a_span', 'bar', 'foo'" do
      @story.should_receive(:match_selector).with("//span.foo//span.bar").and_return @match_selector
      
      @story.multi_check("have_a_span_in_a_span", "bar", "foo")
    end
    
    it "should raise an error 'html tag <p id=\"main\"> is not nested within <div id=\"wrapper\">' 'have_the_paragraph_in_the_box', 'wrapper', 'main' that fails the match" do
      @match_selector.stub!(:matches?).and_return(false)
      @story.should_receive(:match_selector).with("//div#wrapper//p#main").and_return @match_selector
      
      lambda { @story.multi_check("have_the_paragraph_in_the_box", "main", "wrapper") }.should raise_error("html tag <p id=\"main\"> is not nested within a <div id=\"wrapper\"> tag:\n\n#{@story.response.body}")
    end
  end
  
  describe "#have_with_content_check" do
    before(:each) do
      @story.response = mock(:html_response)
      @story.response.stub!(:body)
      @match_selector = mock(:match_selector)
      @match_selector.stub!(:matches?).and_return(true)
    end
    
    it "should call match_selector with \"//p#main[@text*=\"merb blerb\"]\" when called with 'have_the_paragraph_with_content', 'main', 'merb blerb'" do
      @story.should_receive(:match_selector).with("//p#main[@text()*=\"merb blerb\"]").and_return @match_selector
      
      @story.have_with_content_check("have_the_paragraph_with_content", "main", "merb blerb")
    end
    
    it "should call match_selector with \"//p#main[@text=~\"(m|bl)erb\"]\" when called with 'have_the_paragraph_with_content', 'main', /merb|blerb/" do
      @story.should_receive(:match_selector).with("//p#main[@text()~=\"(m|bl)erb\"]").and_return @match_selector
      
      @story.have_with_content_check("have_the_paragraph_with_content", "main", /(m|bl)erb/)
    end
        
    it "should raise an error 'html tag <p id=\"main\"> did not pass the filter: /(m|bl)erb/ when called with 'have_the_paragraph_with_content', 'main', /(m|bl)erb/ that fails the match" do
      @match_selector.stub!(:matches?).and_return(false)
      @story.should_receive(:match_selector).with("//p#main[@text()~=\"(m|bl)erb\"]").and_return @match_selector

      lambda { @story.have_with_content_check("have_the_paragraph_with_content", "main", /(m|bl)erb/) }.should raise_error("html tag <p id=\"main\"> did not pass the filter: /(m|bl)erb/\n\n#{@story.response.body}")
    end
    
    it "should raise an error 'html tag <p id=\"main\"> did not contain the string: \"merb blerb\" when called with 'have_the_paragraph_with_content', 'main', 'merb blerb' that fails the match" do
      @match_selector.stub!(:matches?).and_return(false)
      @story.should_receive(:match_selector).with("//p#main[@text()*=\"merb blerb\"]").and_return @match_selector

      lambda { @story.have_with_content_check("have_the_paragraph_with_content", "main", 'merb blerb') }.should raise_error("html tag <p id=\"main\"> did not contain the string: \"merb blerb\"\n\n#{@story.response.body}")
    end
  end
  
  describe "#check_type" do
    it "should catergorize messages that start with 'have_' as :have" do
      @story.check_type("have_a_h1").should == :have
      @story.check_type("have_an_h2").should == :have
      @story.check_type("have_the_h3").should == :have
    end
    
    it "should categorize messages that start with 'has_' and end with '?' as :have" do
      @story.check_type("has_a_h1?").should == :have
      @story.check_type("has_an_h2?").should == :have
      @story.check_type("has_the_h3?").should == :have
    end
    
    it "should catergorize messages that start with 'with_' as :with" do
      @story.check_type("with_a_h1").should == :with
      @story.check_type("with_an_h2").should == :with
      @story.check_type("with_the_h3").should == :with
    end
    
    it "should categorize messages that start with 'have_' and contain a '_in_' as :multi_have" do
      %w[a an the].each do |first|
        %w[a an the].each do |second|
          @story.check_type("have_#{first}_h1_in_#{second}_box").should == :multi_have
        end
      end
    end
    
    it "should categorize messages that start with 'has_', contain a '_in_', and end with '?' as :multi_have" do
      %w[a an the].each do |first|
        %w[a an the].each do |second|
          @story.check_type("has_#{first}_h1_in_#{second}_box?").should == :multi_have
        end
      end
    end
    
    it "should categorize messages that start with 'have_' and contain a '_with_' as :have_with" do
      %w[a an the].each do |first|
        %w[a an the].each do |second|
          @story.check_type("have_#{first}_box_with_#{second}").should == :have_with
        end
      end
    end
    
    it "should categorize messages that start with 'has_', contain a '_with_', and end with '?' as :have_with" do
      %w[a an the].each do |first|
        %w[a an the].each do |second|
          @story.check_type("has_#{first}_box_with_#{second}?").should == :have_with
        end
      end
    end
    
    it "should categorize messages that start with 'have_' and end with '_with_context' as :have_with_context" do
      %w[a an the].each do |article|
        @story.check_type("have_#{article}_span_with_content").should == :have_with_content
      end
    end
    
    it "should categorize messages that start with 'has_' end with '_with_context?' as :have_with_context" do
      %w[a an the].each do |article|
        @story.check_type("has_#{article}_span_with_content?").should == :have_with_content
      end
    end
  end
end