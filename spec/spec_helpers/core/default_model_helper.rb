module DefaultModelHelper
  
  def create_model
    model = nil
    lambda do
      model = model_class.create!(valid_attributes)
    end.should_not raise_error
    model
  end
  
end
