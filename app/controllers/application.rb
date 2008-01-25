# all your other controllers should inherit from this one to share code.
class Application < Merb::Controller
  require 'authenticated_system'
  include AuthenticatedSystem
end  