# http://www.aidanf.net/rails_user_authentication_tutorial
require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe User do
  before(:each) do
   User.delete_all
   User.create(:id => 1000001, 
               :login => "bob", 
               :salt => 1000, 
               :email => "bob@mcbob.com",
               :hashed_password => "77a0d943cdbace52716a9ef9fae12e45e2788d39") # test
                       
   User.create(:id => 1000002,
               :salt => 1000,
               :login => "existingbob",
               :email => "exbob@mcbob.com",
               :hashed_password => "77a0d943cdbace52716a9ef9fae12e45e2788d39") # test

   User.create(:id => 1000003,
               :salt => 1000,
               :login => "longbob",
               :email => "lbob@mcbob.com",
               :hashed_password => "00728d3362c26746ec25963f71be022b152237a9") # longtest
      
  end
  
  it "should check that a valid user can login" do
    @bob = User.authenticate("bob", "test")
    @bob.should_not be_nil
  end
  
  it "should check that a invalid user cannot login" do 
    @bob = User.authenticate("bob", "test1")
    @bob.should be_nil
  end
  
=begin
  def test_auth 
      #check that we can login we a valid user 
      assert_equal  @bob, User.authenticate("bob", "test")    
      #wrong username
      assert_nil    User.authenticate("nonbob", "test")
      #wrong password
      assert_nil    User.authenticate("bob", "wrongpass")
      #wrong login and pass
      assert_nil    User.authenticate("nonbob", "wrongpass")
    end
=end  
  

end