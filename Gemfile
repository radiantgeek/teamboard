source 'http://rubygems.org'

# weird stuff for linux: see http://stackoverflow.com/questions/6282307/rails-3-1-execjs-and-could-not-find-a-javascript-runtime
gem 'therubyracer', :platforms => :ruby

gem 'rails'

gem 'sqlite3'

# weird stuff for Ruby 1.9.2 on Windows
# 1. comment line 
# 2. `bundle install` 
# 3. install eventmachine and thin: 
# 3.1. `gem install eventmachine --pre`
# 3.2. `gem install thin`
# 4. uncomment line
# 5. `bundle update`
gem 'thin'

gem 'mysql2'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
#gem "haml", ">= 3.0.0"
#gem 'rails3-jquery-autocomplete'
#gem "cucumber-rails", :group => [:development, :test]
#gem "capybara", :group => [:development, :test]
#gem "rspec-rails", ">= 2.0.1", :group => [:development, :test]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '>= 3.1.5'
  gem 'coffee-rails', '>= 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end

gem "devise"
