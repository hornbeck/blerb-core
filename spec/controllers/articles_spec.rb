require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Articles do
  include DefaultSpecHelper
  include DefaultControllerHelper
  include ArticleSpecHelper

  it_should_behave_like "default controller behavior"
end
