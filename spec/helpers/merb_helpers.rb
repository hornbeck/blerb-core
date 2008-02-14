module Merb
  module Test
    module RspecMatchers
      class BeKindOf  
        def initialize(expected) # + args
          @expected = expected
        end

        def matches?(target)
          @target = target         
          @target.kind_of?(@expected)
        end

        def failure_message
          "expected #{@expected} but got #{@target.class}"
        end
        def negative_failure_message
          "expected #{@expected} to not be #{@target.class}"
        end

        def description
          "be_kind_of #{@target}"
        end
      end

      def be_kind_of(expected) # + args
        BeKindOf.new(expected)
      end
    end #BeKindOf

    module Helper
      def running(&blk) blk; end
      def executing(&blk) blk; end
      def doing(&blk) blk; end
      def calling(&blk) blk; end
    end #Helper
  end # Test
end #Merb

class Object
  # Checks that an object has assigned an instance variable of name
  # :name
  # 
  # ===Example in a spec
  #  @my_obj.assings(:my_value).should == @my_value
  def assigns(attr)
    self.instance_variable_get("@#{attr}")
  end   
end
