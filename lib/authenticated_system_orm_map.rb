module AuthenticatedSystem
  module OrmMap
    
    def find_authenticated_model_with_id(id)
      User.first(:id => id)
    end
    
    def find_authenticated_model_with_remember_token(rt)
      User.first(:remember_token => rt)
    end
    
    def find_activated_authenticated_model_with_email(email)
      if User.instance_methods.include?("activated_at")
        User.first(:email => email, :activated_at.not => nil)
      else
        User.first(:email => email)
      end
    end
    
    def find_activated_authenticated_model(activation_code)
      User.first(:activation_code => activation_code)
    end  
    
    def find_with_conditions(conditions)
      User.first(conditions)
    end
    
    # A method to assist with specs
    def clear_database_table
      User.auto_migrate!
    end
  end
  
end