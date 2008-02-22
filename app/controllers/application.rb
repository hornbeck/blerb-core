dependencies "authenticated_system_controller", "merb_helpers"
class Application < Merb::Controller
  include AuthenticatedSystem::Controller
  
  protected
    def get_settings
      Setting.instance
    end
    
    def current_settings
      @current_settings ||= get_settings
    end
end  