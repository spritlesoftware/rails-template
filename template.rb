# ===================================================================================================================
# Spritle Rails application Template
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

begin
	require 'god'
rescue LoadError
	puts        "\n"
	say_status  "ERROR", "Rubygem 'god' not installed\n", :red
	puts        '-'*80
	say_status  "", "gem install god"
	puts        "\n"

	if yes?("Should I install it for you?", :bold)
		say_status "gem", "install god", :yellow
		system "gem install god"
	else
		exit(1)
	end
end

run "touch config/monitor.god"

say_status "Creating god configuration",:yellow

file "config/monitor.god", <<-END.gsub(/  /, '')

rails_env = ENV['RAILS_ENV'] || "development"
rails_root = ENV['RAILS_ROOT'] || "/home/deploy/webapps/project"

def generic_monitoring(w, options = {})
	w.start_if do |start|
		start.condition(:process_running) do |c|
			c.interval = 10.seconds
			c.running = false
			c.notify = {:contacts => ['developers'], :priority => 1}
		end
	end

	w.restart_if do |restart|
		restart.condition(:memory_usage) do |c|
			c.above = options[:memory_limit]
			c.times = [3, 5] # 3 out of 5 intervals
		end

		restart.condition(:cpu_usage) do |c|
			c.above = options[:cpu_limit]
			c.times = 5
			c.notify = {:contacts => ['admin','developers'], :priority => 1}
		end
	end

	w.lifecycle do |on|
		on.condition(:flapping) do |c|
			c.to_state = [:start, :restart]
			c.times = 5
			c.within = 5.minute
			c.transition = :unmonitored
			c.retry_in = 10.minutes
			c.retry_times = 5
			c.retry_within = 2.hours
		end
	end
end


God.contact(:email) do |c|
	c.name = 'myadmin'
	c.group = 'admin'
	c.to_email = 'admin@spritle.com'
end


God.contact(:email) do |c|
	c.name = 'prabu'
	c.group = 'developers'
	c.to_email = 'prabud@spritle.com'
end


God.contact(:email) do |c|
	c.name = 'sivakumar'
	c.group = 'developers'
	c.to_email = 'sivakumarv@spritle.com'
end

God.watch do |w|", <<-END.gsub(/  /, '')
	    w.name          = "redis"
	    w.interval      = 30.seconds
	    w.start         = "/etc/init.d/apache2 start"
	    w.stop          = "/etc/init.d/apache2 stop"
	    w.restart       = "/etc/init.d/apache2 restart"
	    w.start_grace   = 10.seconds
	    w.restart_grace = 10.seconds
 
	    w.start_if do |start|
		      start.condition(:process_running) do |c|
			  c.interval = 5.seconds
			  c.running = false
		      end
  	    end
     generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 1024.megabytes)
  end

God.watch do |w|", <<-END.gsub(/  /, '')
	w.name          = "redis"
	w.interval      = 30.seconds
	w.start         = "/etc/init.d/mysql start"
	w.stop          = "/etc/init.d/mysql stop"
	w.restart       = "/etc/init.d/mysql restart"
	w.start_grace   = 10.seconds
	w.restart_grace = 10.seconds

	w.start_if do |start|
		start.condition(:process_running) do |c|
			c.interval = 5.seconds
			c.running = false
		end
	end
	generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 1024.megabytes)
end
END


say_status "Adding Gems to Gemfile.......", :yellow
gem 'mysql2'
gem 'rest-client'
gem 'haml'
gem 'rspec'
gem 'airborne'
gem 'capistrano', '~> 3.3.0'
gem 'rubocop'
gem 'devise'
gem 'sass-rails', '~> 4.0.3'

gem_group :development, :test do
	gem "rspec-rails"
	gem "better_errors"
	gem "binding_of_caller"
	gem 'brakeman', :require => false
end


run "bundle exec cap install"

say_status "Creating .gitignore file"

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


after_bundle do
  say_status "Successfully created new rails application from Spritle rails Template.", :green
  says_status "Build awesome apps"
end

