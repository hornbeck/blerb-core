steps_for(:user) do
  
  When "they view any application layout based page" do
    @response = get("/")
  end
end