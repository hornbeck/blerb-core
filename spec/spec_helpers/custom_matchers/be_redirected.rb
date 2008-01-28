class BeRedirected
  
  def initialize(expected_path = nil)
    @expected_path = expected_path
  end
  
  def matches?(target)
    raise "#{target.class} is not a controller" unless target.kind_of?(Merb::Controller)
    @target = target
    
    if @expected_path
      @target.status == 302 && @target.headers["Location"] == @expected_path
    else
      @target.status == 302
    end
  end
  
  def failure_message
    if @target.status != 302
      "expected the #{@target.class} controller to be redirected but had status: #{@target.status}"
    else
      "expected the #{@target.class} controller to be redirected to '#{@expected_path}' but was redirected to '#{@target.headers["Location"]}'"
    end
  end
  def negative_failure_message
    "expected the #{@target.class} controller not to route to '#{@expected_path}' but is redirected there"
  end
end


# Checks to see that a controller has the correct status code for a redirect
# ===Example
#   controller.should be_redirected
def be_redirected
  BeRedirected.new
end

# Checks to see that a controller has the correct status code for a redirect
# And is redirected to the correct path
# ===Example
#   controller.should be_redirected_to( url(:new_page) )
def be_redirected_to(path)
  BeRedirected.new(path)
end
