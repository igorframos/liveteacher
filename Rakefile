# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

LiveTeacher::Application.load_tasks

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new('examples_with_rcov') do |t|
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec']
    t.rcov_opts = ['--exclude', 'config']
    t.rcov_opts = ['--exclude', 'app/helpers']
end
