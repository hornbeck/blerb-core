describe "A Restfully Routed Resource", :shared => true do
  
  before(:all) do
    raise "Need to set @restful_resource_path in shared behaviour 'A Restful Resource'" unless @restful_resource_path
    raise "Need to set @restful_resource_path[:base_path]" unless @restful_resource_path[:base_path]
    raise "Need to set @restful_resource_path[:controller]" unless @restful_resource_path[:controller]
  end
  
  before(:each) do
    @rrr_path = @restful_resource_path[:base_path]
    @rrr_controller = @restful_resource_path[:controller]
  end
  
  it "should route to the index action" do
    with_route(@rrr_path) do |params|
      params[:controller].should == @rrr_controller
      params[:action].should     == "index"
    end
  end
  
  it "should route with xml, js and yaml format for the index action" do
    %w(xml js yml).each do |fmt|
      with_route("#{@rrr_path}.#{fmt}") do |p|
        p[:controller].should == @rrr_controller
        p[:action].should     == "index"
        p[:format].should     == fmt
      end
    end   
  end
  
  it "should not route PUT, DELETE or POST requests to index" do
    %w(PUT POST DELETE).each do |meth|
      with_route(@rrr_path, meth){|p| p[:action].should_not == "index"}
    end
  end
  
  it "should route to the show action" do
    with_route("#{@rrr_path}/1", "GET") do |params|
      params[:controller].should == @rrr_controller
      params[:action].should == "show"
      params[:id].should == "1"
    end
  end
  
  it "should route with xml js and yaml format for the show action" do
    %w(xml js yml).each do |fmt|
      with_route("#{@rrr_path}/1.#{fmt}") do |p|
        p[:controller].should == @rrr_controller
        p[:action].should == "show"
        p[:id].should == "1"
        p[:format].should == fmt
      end
    end
  end
  
  it "should not route PUT DELETE or POST requests to show" do
    %w(PUT POST DELETE).each do |meth|
      with_route("#{@rrr_path}/1", meth){|p| p[:action].should_not == "show"}
    end
  end
  
  it "should route to the new action with a GET" do
    with_route("#{@rrr_path}/new", "GET") do |params|
      params[:controller].should == @rrr_controller
      params[:action].should == "new"
    end
  end
  
  it "should not route to the new action with POST, PUT, or DELETE" do
    %W(PUT POST DELETE).each do |meth|
      with_route("#{@rrr_path}/new", meth){|p| p[:action].should_not == "new"}
    end
  end
  
  it "should route to the edit action with a GET" do
    with_route("#{@rrr_path}/1/edit", "GET") do |params|
      params[:controller].should == @rrr_controller
      params[:action].should == "edit"
      params[:id].should == "1"
    end
  end
  
  it "should not route to the edit action with POST, PUT, or DELETE" do
    %w(POST PUT DELETE).each{|p| p[:action].should_not == "edit"}
  end
  
  it "should route to the create action with a POST" do
    with_route(@rrr_path, "POST") do |params|
      params[:controller].should == @rrr_controller
      params[:action].should == "create"
    end
  end
  
  it "should not route to the create action with GET PUT or DELETE" do
    %w(GET PUT DELETE).each do |meth|
      with_route(@rrr_path, meth){|p| p[:action].should_not == "create"}
    end
  end
  
  it "should route to the update action with a PUT" do
    with_route("#{@rrr_path}/1", "PUT") do |params|
      params[:controller].should == @rrr_controller
      params[:action].should == "update"
      params[:id].should == "1"
    end
  end
  
  it "should not route to the update action with GET, POST or DELETE" do
    %w(GET POST DELETE).each do |meth|
      with_route("#{@rrr_path}/1", meth){|p| p[:action].should_not == "update"}
    end
  end
  
  it "should route to the destroy action with DELETE" do
    with_route("#{@rrr_path}/1", "DELETE") do |params|
      params[:controller].should == @rrr_controller
      params[:action].should == "destroy"
      params[:id].should == "1"
    end
  end
  
  it "should not route to the destroy action with GET, PUT, or POST" do
    %w(GET POST PUT).each do |meth|
      with_route("#{@rrr_path}/1", meth){|p| p[:action].should_not == "destroy"}
    end
  end
end
