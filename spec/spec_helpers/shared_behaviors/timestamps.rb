describe "timestamps work correctly", :shared => true do
  attr_reader :now, :model
  before do
    @now = Time.now
    Time.stub!(:now).and_return(now)
    
    @model = create_model
    model.should_not be_nil
  end
  
  it "should set the timestamps correctly on create" do
    model.created_at.should == now
    model.updated_at.should == now
  end
  
  it "should only update udpated_at on save" do
    later_time = now + 10
    Time.stub!(:now).and_return(later_time)
    
    model.update_attributes(updated_attributes).should be_true
    model.created_at.should == now
    model.updated_at.should == later_time
  end
end
