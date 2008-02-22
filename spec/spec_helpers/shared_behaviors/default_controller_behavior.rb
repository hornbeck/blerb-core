describe "default controller behavior", :shared => true do
  before(:each) do
    @controller_instance = controller_class.new(Merb::Test::FakeRequest.new)
    model_class.delete_all
  end

  def controller_instance
    @controller_instance 
  end

  describe "#index" do
    it "returns an empty array without error if there are no models created" do
      if controller_instance.respond_to? :index
        dispatch_to(controller_class, :index).assigns(controller_sym).should_not be_nil       
        dispatch_to(controller_class, :index).assigns(controller_sym).should == []
        dispatch_to(controller_class, :index).assigns(controller_sym).should be_empty
      end
    end
 
    it "returns all models as an assigns" do
      if controller_instance.respond_to? :index
        expected_models = []
        4.times do
          new_model = mock(controller_name.singularize)
          mock_attributes.each do |attr_name, attr_value|
            new_model.stub!(attr_name).and_return(attr_value)
          end
          expected_models << new_model
        end
        model_class.should_receive(:all).and_return(expected_models)

        dispatch_to(controller_class, :index).assigns(controller_sym).should == expected_models
      end
    end
  end
  
  describe "#show" do
    it "should fail for a model that doesn't exist" do
      if controller_instance.respond_to? :show
        lambda {dispatch_to(controller_class, :show, :id => invalid_id)}.
          should raise_error(Merb::ControllerExceptions::NotFound)
      end
    end
   
    it "should show a model if given a valid model" do
      if controller_instance.respond_to? :show 
        new_model = model_class.create(valid_attributes)
        new_model.class.should == model_class

        controller = dispatch_to(controller_class, :show, :id => new_model.slug)
        controller.assigns(model_sym).id.should == new_model.id
      end
    end
  end
  
  describe "#new" do
    it "returns a new non-persisted model object" do
      if controller_instance.respond_to? :new
        controller = dispatch_to(controller, :new, {:method => :get})
        new_model = controller.assigns(model_sym)
   
        new_model.should_not be_nil
        new_model.should be_new_record
      end
    end
  end
  
  describe "#create" do
    it 'should add a new mode to the database if all attributes present' do
      if controller_instance.respond_to? :create
        lambda do
          controller = dispatch_to(controller, :create, {:method => :post, model_sym => valid_attributes})
          controller.should redirect
        end.should change(model_class, :count).by(1)
      end
    end
  
    it 'fails on required attributes' do
      if controller_instance.respond_to? :create
        if required_fields.is_a? Symbol
          check_required_field(required_fields)
        elsif required_fields.is_a? String
          check_required_field(required_fields.to_sym)
        elsif required_fields.is_a? Array
          required_fields.each do |field|
            check_required_field(field.to_sym)
          end
        end
      end
    end
  end

  describe "#edit" do
    it "should return status 404 for a model that doesn't exist" do
      if controller_instance.respond_to? :edit
        controller = dispatch_to(controller, :edit, {:id => invalid_id})
        controller.should_not be_successful
        controller.assigns(model_sym).should be_nil
      end
    end
  
    it "should not throw an error if given a valid model" do
      if controller_instance.respond_to? :edit
        controller = dispatch_to(controller, :create, {:method => :post, model_sym => valid_attributes}) 
        new_model = controller.assigns model_sym
        new_model.should_not be_nil
  
        controller = dispatch_to(controller, :edit, {:id => new_model.id})
  
        controller.should be_successful
        controller.assigns(model_sym).id.should == new_model.id
      end
    end
  end

  describe "#update" do
    it "should return status 404 for a model that doesn't exist" do
      if controller_instance.respond_to? :update
        controller = dispatch_to(controller, :update, {:id => invalid_id})
  
        controller.should_not be_successful
        controller.assigns(model_sym).should be_nil
      end
    end
  
    it "should fail on an update with invalid attributes" do
      if controller_instance.respond_to? :update
        controller = dispatch_to(controller, :create, {:method => :post, model_sym => valid_attributes}) 

        new_model = controller.assigns model_sym
        new_model.should_not be_nil
  
        controller = dispatch_to(controller, :update, {:method => :post,:id => new_mode.id, :name => nil})
  
        controller.should_not be_successful
        controller.assigns(model_sym).should be_nil
      end
    end
   
    it "should update the proper model on a well formed request" do
      if controller_instance.respond_to? :update
        now = DateTime.now
        later = now+10
        Time.stub!(:now).and_return(now)

        controller = dispatch_to(controller, :create, {:method => :post, model_sym => valid_attributes}) 
        new_model = model_class.find(controller.assigns(model_sym).id)
        new_model.should_not be_nil
        new_model.created_at.should == now
        new_model.updated_at.should == now
  
        Time.stub!(:now).and_return(later)
  
        controller = dispatch_to(controller_class, :update, {:id => new_model.id, model_sym => updated_attributes})
  
        controller.should redirect_to("/#{controller_name}/#{new_model.id}")
        new_model = model_class.find(new_model.id)
        new_model.created_at.should == now
        new_model.updated_at.should == later
      end
    end
  end

  describe "#destroy" do
    it "should return status 404 for a model that doesn't exist" do
      if controller_instance.respond_to? :destroy
        dispatch_to(controller_class, :destroy, :id => invalid_id).should_not be_successful
      end
    end
   
    it "should delete a valid model" do
      if controller_class.respond_to? :destroy
        
        controller = do_create
        new_model = controller.assigns(model_sym)
  
        new_model.should_not be_nil
        controller = do_destroy(new_model.id)
  
        controller.should redirect_to("/#{controller_name}")
        model_class.find(new_model.id).should be_nil
      end
    end
  end

  def check_required_field(field_sym)
    calling do
      controller = do_create(field_sym => nil)
    end.should_not change(model_class, :count)

    controller.assigns(model_sym).errors.on(field_sym).should_not be_nil
    controller.should be_successful
  end
end

