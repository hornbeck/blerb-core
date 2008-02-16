module DefaultControllerHelper
  # This module will help in abstracting generic REST like controller
  # functionality (at the cost of code clarity)
  #
  # The class assumes the following methods are available
  # - controller_class #=> ie: Articles
  # - model_sym        #=> ie: :article
  # - valid_attributes #=> ie {:title => "test title", :body => "test body"}

  def do_create(options = {})
    # in case the controller doesn't support create, fake this out by creating a new model
    # and sticking it into the instance variable (so assigns will retrieve it properly)
    if controller.respond_to? :create
      controller = hit_controller(:post, model_sym => valid_attributes.merge(options))
    else
      new_model = model_class.create(valid_attributes.merge(options))
      controller.set_assigns(model_sym, new_model)
    end
    return controller
  end

 protected
  def hit_controller(method, params)
    calling do
       controller = dispatch_to(controller_class, method, params).stub!(:render)
    end.should_not raise_error
    return controller
  end
end
