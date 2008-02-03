require File.dirname(__FILE__) + '/has_tag_helper'
require 'spec'
require 'hpricot'

describe HasTag do
  describe "#matches?" do
    it "should call Hpricot.parse is not a Hpricot element or StringIO parameters" do
      ht = HasTag.new("tag")
      Hpricot.should_receive(:parse).with(:unrecognized).and_return(Hpricot::Elem.new("tag"))
      
      ht.matches?(:unrecognized)
    end
  end
  
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
end