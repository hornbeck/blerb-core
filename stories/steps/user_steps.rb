steps_for(:user) do
  
  Given "there is an unregistered user" do
    #again, nothing to do yet...
  end
  
  When "they view the signup page" do
    #not sure how to do this with url()
    @response = get("/signup")
  end
end