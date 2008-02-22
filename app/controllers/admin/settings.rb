module Admin
  class Settings < Application
    self._layout = 'admin'
    
    def edit
      @setting = Setting.load
      render
    end
  
    def update(setting)
      @setting = Setting.new({"settings" => setting})
      @setting.save
      redirect url(:edit_settings)
    end
  end
end