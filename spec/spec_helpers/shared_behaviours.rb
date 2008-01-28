dir = File.dirname(__FILE__)
Dir["#{dir}/shared_behaviors/**/*.rb"].each do |file|
  require file
end