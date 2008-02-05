require File.dirname(__FILE__) + '/has_tag_helper'
require 'spec'

describe HasTag do
  describe "#selector" do
    it "should always start with \/\/" do
      HasTag.new("tag").selector.should =~ /^\/\//
    end
    
    it "should use @tag for the element" do
      HasTag.new("tag").selector.should include("tag")
    end
    
    it "should use dot notation for the class" do
      HasTag.new("tag", :class => "class").selector.should include("tag.class")
    end
    
    it "should use pound(#) notation for the id" do
      HasTag.new("tag", :id => "id").selector.should include("tag#id")
    end
    
    it "should include any custom attributes" do
      HasTag.new("tag", :random => :attribute).selector.should include("[@random=\"attribute\"]")
    end
    
    it "should not include the class as a custom attribute" do
      HasTag.new("tag", :class => :my_class, :rand => :attr).selector.should_not include("[@class=\"my_class\"]")
    end
    
    it "should not include the id as a custom attribute" do
      HasTag.new("tag", :id => :my_id, :rand => :attr).selector.should_not include("[@id=\"my_id\"]")
    end
  end
  
  describe "#failure_message" do
    it "should include the tag name" do
      HasTag.new("anytag").failure_message.should include("<anytag")
    end
    
    it "should include the tag's id" do
      HasTag.new("div", :id => :spacer).failure_message.should include("<div id=\"spacer\"")
    end
    
    it "should include the tag's class" do
      HasTag.new("div", :class => :header).failure_message.should include("<div class=\"header\"")
    end
    
    it "should include the tag's custom attributes" do
      HasTag.new("h1", :attr => :val, :foo => :bar).failure_message.should include("attr=\"val\"")
      HasTag.new("h1", :attr => :val, :foo => :bar).failure_message.should include("foo=\"bar\"")
    end
    
    it "should include the filter string inside the tag" do
      HasTag.new("h2", "Subtitle String", :id => :subtitle).failure_message.should include("Subtitle String")
    end
    
    it "should include the filter regexp inside the tag" do
      HasTag.new("h3", /title/).failure_message.should include("/title/")
    end
  end
  
  describe "id, class, and attributes for error messages" do
    it "should start with a space for a class, id, or custom attribute" do
      HasTag.new("tag", :id => "identifier").id_for_error.should =~ /^ /
      HasTag.new("tag", :class => "classifier").class_for_error.should =~ /^ /
      HasTag.new("tag", :rand => "attr").attributes_for_error.should =~ /^ /
    end
    
    it "should have 'class=\"classifier\"' in class_for_error" do
      HasTag.new("tag", :class => "classifier").class_for_error.should include("class=\"classifier\"")
    end
    
    it "should have 'id=\"identifier\" in id_for_error" do
      HasTag.new("tag", :id => "identifier").id_for_error.should include("id=\"identifier\"")
    end
  end
end