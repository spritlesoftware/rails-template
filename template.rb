# ===================================================================================================================
# Spritle Rails Application Template
# ===================================================================================================================
# Email: info@spritle.com
# Website: www.spritle.com
#
#
# Requirements
# -------------------------------------------------------------------------------------------------------------------
# * Git
# * Ruby >= 1.8.7
# * Rubygems
# * Rails >= 3
#
# Usage
# -----
#
#     $ rails new AppName -m template.rb
#
# ===================================================================================================================

require 'rubygems'

say_status "Adding Gems to Gemfile.......", :yellow

gem 'mysql2'
gem 'rest-client'
gem 'haml'
gem 'rspec'
gem 'airborne'
gem 'capistrano' 
gem 'rubocop'
gem 'devise'
gem 'sass-rails' 

gem_group :development, :test do
	gem "rspec-rails"
	gem "better_errors"
	gem "binding_of_caller"
	gem 'brakeman', :require => false
end




say_status "Creating .gitignore file", :yellow

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "rm -f .gitignore"
file ".gitignore", <<-END.gsub(/  /, '')
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END
git :init




