module DefaultSpecHelper
  
  def invalid_id
    '99999'
  end
  
  def controller_name
    controller_class.to_s.downcase
  end
  
  def controller_sym
    controller_name.to_sym
  end
  
  def model_sym
    model_class.to_s.downcase.to_sym
  end
  
end
