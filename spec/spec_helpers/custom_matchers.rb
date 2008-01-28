dir = File.dirname(__FILE__)
Dir["#{dir}/custom_matchers/**/*.rb"].each do |file|
  require file
end