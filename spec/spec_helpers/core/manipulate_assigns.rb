class Object
  # Insert an object into the instance variables of another object so it will be
  # properly retrieved by the Object#assigns call
  # 
  # ===Example in a spec
  #  @my_obj.set_assigns(:attribute, my_value)
  #
  #  @my_obj.assigns(:attribute).should == my_value
  def set_assigns(attribute, value)
    self.instance_variable_set("@#{attribute.to_s}", value)
  end
end

