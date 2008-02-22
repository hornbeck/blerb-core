module Admin
  class Settings < Application
    self._layout = 'admin'
    
    def edit
      @setting = Setting.instance
      render
    end
  
    def update(setting)
      @setting = Setting.new({"settings" => setting})
      @setting.save
      redirect url(:edit_admin_settings)
    end
  end
end