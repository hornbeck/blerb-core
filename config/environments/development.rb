puts "Loaded DEVELOPMENT Environment..."
Merb::Config.use do |c|
  c[:exception_details] = true
  c[:reload_classes] = true
  c[:reload_time] = 0.5
end
