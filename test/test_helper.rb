require File.join(File.dirname(__FILE__), "..", 'config', 'boot')

$TESTING=true

require 'rubygems'
require 'test/unit'
require File.join(MERB_ROOT, 'config', 'merb_init')

require 'merb/test/helper'

class Test::Unit::TestCase
  # Add more helper methods to be used by all tests here...
end