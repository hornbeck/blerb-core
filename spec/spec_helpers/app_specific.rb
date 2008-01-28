dir = File.dirname(__FILE__)
Dir["#{dir}/app_specific/**/*.rb"].each do |file|
  require file
end