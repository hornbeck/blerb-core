dir = File.dirname(__FILE__)
Dir["#{dir}/core/**/*.rb"].each do |file|
  require file
end