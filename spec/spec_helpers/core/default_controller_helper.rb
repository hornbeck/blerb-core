module DefaultControllerHelper
  
  def do_index()
    hit_controller(:get, url(controller_sym))
  end

  def do_create(options = {})
    # in case the controller doesn't support create, fake this out by creating a new model
    # and sticking it into the instance variable (so assigns will retrieve it properly)
    if controller.respond_to? :create
      hit_controller(:post, url(controller_sym, model_sym => valid_attributes.merge(options)))
    else
      new_model = model_class.create(valid_attributes.merge(options))
      controller.instance_variable_set("@#{model_sym.to_s}", new_model)
    end
  end

  def do_show(id)
    hit_controller(:get, "/#{controller_name}/#{id}")
  end
  
  def do_edit(id)
    hit_controller(:get, "/#{controller_name}/#{id}/edit")
  end
  
  def do_update(id, options = {})
    hit_controller(:put, url("/#{controller_name}/#{id}", model_sym => options))
  end
  
  def do_new
    hit_controller(:get, "/#{controller_name}/new")
  end
  
  def do_destroy(id)
    hit_controller(:delete, "/#{controller_name}/#{id}")
  end
  
  protected
  
  def hit_controller(method, route_url)
    my_request = Merb::Test::FakeRequest.with(route_url, {:request_method => method.to_s})
    lambda do
      request(method, route_url, :yields => :controller, :fake_request => my_request) do
        controller.stub!(:render)
      end
    end.should_not raise_error
  end
end
