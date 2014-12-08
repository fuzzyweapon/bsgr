$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require 'aresmush'
require 'erubis'
require 'rspec'
require 'rspec/core/rake_task'
require 'tempfile'
require 'mongoid'
require_relative 'install/init_db.rb'
require_relative 'install/configure_game.rb'

task :start do
  bootstrapper = AresMUSH::Bootstrapper.new
  bootstrapper.command_line.start
end
  
task :configure do
  AresMUSH::Install.configure_game
end

task :init do    
  bootstrapper = AresMUSH::Bootstrapper.new
  AresMUSH::Install.init_db
end

task :upgrade, [:scriptname] do |t, args|
  scriptname = args[:scriptname]
  require_relative "install/upgrades/#{scriptname}.rb"
end

desc "Run all specs."
begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec, :tag) do |t, task_args|
    tag = task_args[:tag]
    if (tag)
      t.rspec_opts = "--example #{tag}"
    end
  end
rescue LoadError
  # no rspec available
end

desc "Run all specs except the db ones."
begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new('spec:unit', :tag) do |t, task_args|
    t.rspec_opts = "--tag ~dbtest"
  end
rescue LoadError
  # no rspec available
end

task :default => 'spec:unit'

