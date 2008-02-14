class Merb::Controller
  require "merb-core/dispatch/session/memory"
  Merb::MemorySessionContainer.setup
  #include ::Merb::SessionMixin
  #Merb::Config[:session_secret_key] = "rawrrawr"
end

class Merb::Mailer
  self.delivery_method = :test_send
end

class Hash
  
  def with( opts )
    self.merge(opts)
  end
  
  def without(*args)
    self.dup.delete_if{ |k,v| args.include?(k)}
  end
  
end
