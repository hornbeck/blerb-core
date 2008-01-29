describe "default controller behavior", :shared => true do
  before(:each) do
    @controller = controller_class.build(fake_request)
    model_class.delete_all
  end

  describe "#index" do
    it "returns an empty array without error if there are no models created" do
      if controller.respond_to? :index
        do_index
    
        controller.assigns(controller_sym).should_not be_nil
        controller.assigns(controller_sym).should == []
        controller.assigns(controller_sym).should be_empty
        controller.should be_successful
      end
    end
 
    it "returns all models as an assigns" do
      if controller.respond_to? :index
        expected_models = []
        4.times do
          new_model = mock(controller_name.singularize)
          valid_attributes.each do |attr_name, attr_value|
            new_model.stub!(attr_name).and_return(attr_value)
          end
          expected_models << new_model
        end
        model_class.should_receive(:all).and_return(expected_models)

        do_index
    
        controller.assigns(controller_sym).should == expected_models
        controller.should be_successful
      end
    end
  end
  
  describe "#show" do
    it "should fail for a model that doesn't exist" do
      if controller.respond_to? :show
        do_show(invalid_id)
        controller.assigns(model_sym).should be_nil
        controller.should_not be_successful
      end
    end
   
    it "should not throw an error if given a valid model" do
      if controller.respond_to? :show
        do_create
        new_model = controller.assigns model_sym
        new_model.should_not be_nil
  
        do_show(new_model.id)
  
        controller.should be_successful
        controller.assigns(model_sym).id.should == new_model.id
      end
    end
  end
  
  describe "#new" do
    it "returns a new non-persisted model object" do
      if controller.respond_to? :new
        do_new
        new_model = controller.assigns(model_sym)
   
        new_model.should_not be_nil
        new_model.should be_new_record
      end
    end
  end
  
  describe "#create" do
    it 'should add a new mode to the database if all attributes present' do
      if controller.respond_to? :create
        lambda do
          do_create
          controller.should redirect      
        end.should change(model_class, :count).by(1)
      end
    end
  
    it 'fails on required attributes' do
      if controller.respond_to? :create
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
      if controller.respond_to? :edit
        do_edit(invalid_id)
  
        controller.should_not be_successful
        controller.assigns(model_sym).should be_nil
      end
    end
  
    it "should not throw an error if given a valid model" do
      if controller.respond_to? :edit
        do_create
        new_model = controller.assigns model_sym
        new_model.should_not be_nil
  
        do_edit(new_model.id)
  
        controller.should be_successful
        controller.assigns(model_sym).id.should == new_model.id
      end
    end
  end

  describe "#update" do
    it "should return status 404 for a model that doesn't exist" do
      if controller.respond_to? :update
        do_update(invalid_id)
  
        controller.should_not be_successful
        controller.assigns(model_sym).should be_nil
      end
    end
  
    it "should fail on an update with invalid attributes" do
      if controller.respond_to? :update
        do_create
        new_model = controller.assigns model_sym
        new_model.should_not be_nil
  
        do_update(new_model.id, :name => nil)
  
        controller.should_not be_successful
        controller.assigns(model_sym).should be_nil
      end
    end
   
    it "should update the proper model on a well formed request" do
      if controller.respond_to? :update
        now = DateTime.now
        later = now+10
        Time.stub!(:now).and_return(now)
        do_create
        new_model = model_class.find(controller.assigns(model_sym).id)
        new_model.should_not be_nil
        new_model.created_at.should == now
        new_model.updated_at.should == now
  
        Time.stub!(:now).and_return(later)
  
        do_update(new_model.id, updated_attributes)
  
        controller.should redirect_to("/#{controller_name}/#{new_model.id}")
        new_model = model_class.find(new_model.id)
        new_model.created_at.should == now
        new_model.updated_at.should == later
      end
    end
  end

  describe "#destroy" do
    it "should return status 404 for a model that doesn't exist" do
      if controller.respond_to? :destroy
        do_destroy invalid_id
  
        controller.should_not be_successful
      end
    end
   
    it "should delete a valid model" do
      if controller.respond_to? :destroy
        do_create
        new_model = controller.assigns(model_sym)
  
        new_model.should_not be_nil
        do_destroy new_model.id
  
        controller.should redirect_to("/#{controller_name}")
        model_class.find(new_model.id).should be_nil
      end
    end
  end

  def check_required_field(field_sym)
    lambda do
      do_create(field_sym => nil)
    end.should_not change(model_class, :count)

    controller.assigns(model_sym).errors.on(field_sym).should_not be_nil
    controller.should be_successful
  end

end

