# Add your own ruby code here for app specific stuff. This file gets loaded
# after the framework is loaded.
puts "Started merb_init.rb ..."

# Your app's dependencies, including your database layer (if any) are defined
# in config/dependencies.rb
require File.join(MERB_ROOT, 'config', 'dependencies')

# Here's where your controllers, helpers, and models, etc. get loaded.  If you
# need to change the order of things, just move the call to 'load_application'
# around this file.
puts "Loading Application..."
Merb::Server.load_application

# Load environment-specific configuration
require File.join(MERB_ROOT, 'config', 'environments', MERB_ENV)
