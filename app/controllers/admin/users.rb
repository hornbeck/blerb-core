module Admin
  class Users < Application
    self._layout = 'admin'
  
    def index
      @users = User.all
      display @users
    end
  
    def show(id)
      @user = User[id]
      raise NotFound unless @user
      display @user
    end
  
    def new
      only_provides :html
      @user = User.new
      display @user
    end
  
    def create(user)
      @user = User.new(user)
      if @user.save
        redirect url(:user, @user)
      else
        render :new
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