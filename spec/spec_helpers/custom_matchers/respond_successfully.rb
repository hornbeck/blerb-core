# A matcher to check that a controller has responded with a success code
class RespondSuccessfully
  
  def matches?(target)
    raise "#{target.class} is not a controller" unless target.kind_of?(Merb::Controller)
    @target = target
    
    @target.status == 200
  end
  
  def failure_message
    "expected controller #{@target.class} to be successful, but had a status code of #{@target.status}"
  end
  
  def negative_failure_message
    "expected controller #{@target.class} to be unsucessful, but was successful"
  end
end

# Use this matcher to check that a controller action was successful
# === Example
#   controller.should respond_successfully
def respond_successfully
  RespondSuccessfully.new
end