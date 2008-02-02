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
      
      it "should return ['h1', nil, {:class => 'main-title'}] for 'a main-title h1'" do
        tag_filter_and_attributes('a main-title h1').should == ["h1", nil, {:class => 'main-title'}]
      end

      it "should return ['div', nil, {:class => 'alternate'}] for 'an alternate div'" do
        tag_filter_and_attributes('an alternate div').should == ["div", nil, {:class => 'alternate'}]
      end

      it "should return ['div', {:id => 'main'}] for 'the main div'" do
        tag_filter_and_attributes('the main div').should == ["div", nil, {:id => 'main'}]
      end
      
      it "should return ['span', 'my text', {}] for 'a \"value\" attr" do
        tag_filter_and_attributes('a "value" attr').should == [nil, nil, {:attr => "value"}]
      end
      
      it "should return [nil, nil, {:attribute => /my expression/}] for 'a 'my expression' attribute'" do
        tag_filter_and_attributes("a 'my expression' attribute").should == [nil, nil, {:attribute => /my expression/}]
      end
      
      it "should return [nil, nil,{:text => 'inner'}] for '\"inner\" text'" do
        tag_filter_and_attributes('"inner" text').should == [nil, nil,{:text => "inner"}]
      end
      
      it "should return [nil, nil, {:regexp => /expression/}] for \"'expression' p\"" do
        tag_filter_and_attributes("'expression' regexp").should == [nil, nil, {:regexp => /expression/}]
      end
      
      it "should return ['div', nil, {}] for 'a box'" do
        tag_filter_and_attributes("a box").should == ["div", nil, {}]
      end
      
      it "should return ['img', nil, {}] for 'an image'" do
        tag_filter_and_attributes("an image").should == ["img", nil, {}]
      end
      
      it "should return ['h1', nil, {}] for 'the title'" do
        tag_filter_and_attributes("the title").should == ["h1", nil, {}]
      end
      
      it "should return ['p', nil, {}] for 'paragraph'" do
        tag_filter_and_attributes("paragraph").should == ["p", nil, {}]
      end
    end
    
    it "should lookup the tag from the TAG_MAP" do
      BoxyStories::TAG_MAP["box"].should == "div"
      tag_filter_and_attributes('a main box').first.should == tag_filter_and_attributes('a main div').first
    end
    
    it "should treat single and double quoted portions followed by a word as attributes" do
      tag, filter, attributes = tag_filter_and_attributes('"My Value" value')
      attributes[:value].should == "My Value"
    end
    
    it "should treat single and double quoted portions as filters" do
      tag, filter, attributes = tag_filter_and_attributes('"My Title"')
      filter.should == "My Title"
    end
    
    it "should treat single quoted portions as a regex filter" do
      tag, filter, attributes = tag_filter_and_attributes("'expression'")
      filter.should == /expression/
    end
    
    it "should treat double quoted portions as a string filter" do
      tag, filter, attributes = tag_filter_and_attributes('"some random string"')
      filter.should == "some random string"
    end
  end
end