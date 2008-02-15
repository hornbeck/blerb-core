steps_for(:user) do
  
  Given "there is an unregistered user" do
    #again, nothing to do yet...
  end
  
  When "they view the signup page" do
    @response = get(url(:signup))
  end
end