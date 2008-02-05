module Admin
  class Users < Application
    self._layout = 'admin'
  
    def index
      @users = User.all
      render @users
    end
  
    def show(id)
      @user = User[id]
      raise NotFound unless @user
      render @user
    end
  
    def new
      only_provides :html
      @user = User.new
      render @user
    end
  
    def create(user)
      @user = User.new(user)
      if @user.save
        redirect url(:user, @user)
      else
        render :action => :new
      end
    end
  
    def edit(id)
      only_provides :html
      @user = User[id]
      raise NotFound unless @user
      render
    end
  
    def update(id, user)
      @user = User[id]
      raise NotFound unless @user
      if @user.update_attributes(user)
        redirect url(:user, @user)
      else
        raise BadRequest
      end
    end
  
    def destroy(id)
      @user = User[id]
      raise NotFound unless @user
      if @user.destroy!
        redirect url(:users)
      else
        raise BadRequest
      end
    end
  end
end