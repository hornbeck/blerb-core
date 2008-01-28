describe "validates required fields", :shared => true do
  it "gets an error message on all required fields" do
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
  
  it "succeeds when all validations are satisfied" do
    model = model_class.new(valid_attributes)
    
    model.should be_valid
    model.save.should be_true
  end
  
  def check_required_field(field_sym)
    model = model_class.new(valid_attributes.merge({field_sym => nil}))
    
    model.should_not be_valid
    model.errors.on(field_sym).should_not be_blank
  end
end

