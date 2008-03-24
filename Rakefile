require 'rubygems'
Gem.clear_paths
Gem.path.unshift(File.join(File.dirname(__FILE__), "gems"))

require 'rake'
require 'spec/rake/spectask'
require 'fileutils'
require 'merb-core'

$RAKE_ENV = true

init_env = ENV['MERB_ENV'] || 'rake'
Merb.load_dependencies(:environment => init_env)

include FileUtils
Merb::Plugins.rakefiles.each {|r| require r }

# Make the default task run specs for now
task :default => [:specs]

desc "load merb_init.rb"
task :merb_init do
  # deprecated - here for BC
  # Rake::Task['merb_env'].invoke
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end

desc 'Run all tests, specs and finish with rcov'
task :aok do
  sh %{rake rcov}
  sh %{rake spec}
end

unless Gem.cache.search("haml").empty?
  namespace :haml do
    desc "Compiles all sass files into CSS"
    task :compile_sass do
      gem 'haml'
      require 'sass'
      puts "*** Updating stylesheets"
      Sass::Plugin.update_stylesheets
      puts "*** Done"      
    end
  end
end

##############################################################################
# SVN
##############################################################################

desc "Add new files to subversion"
task :svn_add do
   system "svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add"
end
