# Boosted from merki
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

# Checks that a route is made to the correct controller etc
# 
# === Example
# with_route("/pages/1", "PUT") do |params|
#   params[:controller].should == "pages"
#   params[:action].should == "update"
#   params[:id].should == "1"
# end
def with_route(the_path, _method = "GET")
  result = Merb::Router.match(fake_request(the_path, _method), {})
  yield result[1] if block_given?
  result
end 

def fixtures(*files)
  files.each do |name|
    klass = Kernel::const_get(Inflector.classify(Inflector.singularize(name)))
    entries = YAML::load_file(File.dirname(__FILE__) + "/fixtures/#{name}.yaml")
    entries.each do |name, entry|
      klass::create(entry)
    end
  end
end


# Dispatches an action to a controller.  Defaults to index.  
# The opts hash, if provided will act as the params hash in the controller
# and the params method in the controller is infact the provided opts hash
# This controller is based on a fake_request and does not go through the router
# 
# === Simple Example
#  {{{
#    controller, result = dispatch_to(Pages, :show, :id => 1, :title => "blah")
#  }}}
#
# === Complex Example
# By providing a block to the dispatch_to method, the controller may be stubbed or mocked prior to the 
# actual dispatch action being called.
#   {{{
#     controller, result = dispatch_to(Pages, :show, :id => 1) do |controller|
#       controller.stub!(:render).and_return("rendered response")
#     end
#   }}}
def dispatch_to(controller, action = :index, opts = {})
  klass = controller.class == Class ? controller : controller.class
  klass.stub!(:find_by_title).and_return(@page)
  the_controller = klass.build(fake_request)
  the_controller.stub!(:params).and_return(opts.merge!(:controller => "#{klass.name.downcase}", :action => action.to_s))
  
  yield the_controller if block_given?
  
  [the_controller, the_controller.dispatch(action.to_sym)]
end

  
