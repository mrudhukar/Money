#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Money::Application.load_tasks


desc "Clean DB"
task :cleandb => :environment do
	Rake::Task["db:drop"].invoke
	Rake::Task["db:create"].invoke
	Rake::Task["db:migrate"].invoke
end


desc "Create First User"
task :create_admin do
	User.create do |u|
		u.name = "Admin"
		u.email = "arun15thmay@gmail.com"
		u.password = "Money_123"
		u.password_confirmation = "Money_123"
	end
end
