require File.dirname(__FILE__) + '/boxy_helper'
require 'spec'

describe BoxyStories do
  describe "#tag_filter_and_attributes" do
    describe "examples" do
      it "should return ['div', nil, {:class => 'main'}] for 'a main div'" do
        tag_filter_and_attributes('a main div').should == ["div", nil, {:class => "main"}]
      end

      it "should return ['div', nil, {:class => 'main'}] for 'a main div'" do
        tag_filter_and_attributes('a main div').should == ["div", nil, {:class => 'main'}]
      end

      it "should return ['div', nil, {:class => 'alternate'}] for 'an alternate div'" do
        tag_filter_and_attributes('an alternate div').should == ["div", nil, {:class => 'alternate'}]
      end

      it "should return ['div', {:id => 'main'}] for 'the main div'" do
        tag_filter_and_attributes('the main div').should == ["div", nil, {:id => 'main'}]
      end
      
      it "should return ['span', 'my text', {}] for 'a \"my text\" span" do
        tag_filter_and_attributes('a "my text" span').should == ["span", "my text", {}]
      end
      
      it "should return ['span', /my expression/ , {}] for 'a 'my expression' span" do
        tag_filter_and_attributes("a 'my expression' span").should == ["span", /my expression/, {}]
      end
    end
    
    it "should lookup the tag from the TAG_MAP" do
      BoxyStories::TAG_MAP["box"].should == "div"
      tag_filter_and_attributes('a main box').first.should == tag_filter_and_attributes('a main div').first
    end
    
    it "should treat single and double quoted portions as filters" do
      tag, filter, attributes = tag_filter_and_attributes('a "My Title" h1')
      filter.should == "My Title"
    end
    
    it "should treat single quoted portions as a regex filter" do
      tag, filter, attributes = tag_filter_and_attributes("a 'expression' h2")
      filter.should == /expression/
    end
    
    it "should treat double quoted portions as a string filter" do
      tag, filter, attributes = tag_filter_and_attributes('a "some random string" h1')
      filter.should == "some random string"
    end
  end
end