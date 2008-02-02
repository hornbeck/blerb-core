require File.dirname(__FILE__) + '/has_tag_helper'
require 'spec'
require 'hpricot'

describe HasTag do
  describe "#matches?" do
    it "should call Hpricot.parse on unrecoginzed parameters" do
      ht = HasTag.new("tag")
      Hpricot.should_receive(:parse).with(:unrecognized)
      
      ht.matches?(:unrecognized)
    end
  end
end