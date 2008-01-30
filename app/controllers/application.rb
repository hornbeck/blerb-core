dependencies "authenticated_system_controller", "merb_helpers"
class Application < Merb::Controller
  include AuthenticatedSystem::Controller
end  