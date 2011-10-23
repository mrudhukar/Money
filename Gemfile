source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'rake', '0.9.2'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'client_side_validations'

# Deploy with Capistrano
# gem 'capistrano'
gem 'authlogic'
gem 'will_paginate', '~> 3.0.0'

group :development, :test do
#  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'therubyracer'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :production do
  gem 'pg'
  gem 'therubyracer-heroku',  '0.8.1.pre3'
end