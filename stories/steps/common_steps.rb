steps_for(:boxy) do
  Given "there is a user" do
    #no reason to do anything yet...
  end
  
  When "they view the homepage" do
    @response = get("/")
  end
end