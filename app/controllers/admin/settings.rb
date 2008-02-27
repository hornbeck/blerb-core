module Admin
  class Settings < Application
    self._layout = 'admin'
    
    def edit
      @setting = Setting.instance
      render
    end
  
    def update(setting)
      debugger
      @setting = Setting.new({"settings" => setting})
      @setting.save
      redirect url(:edit_settings)
    end
  end
end