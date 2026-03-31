source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.5'

gem 'psych', ' < 4' # ruby 3.4 workaround for breaking changes in more recent version of psych
gem 'abbrev' # ruby 3.4.5 workaround, for some reason irb crashes during tab-completion

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.0.2'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use pg as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 6.4', '>= 6.4.2'
gem "importmap-rails"
# Use JavaScript bundling [https://github.com/rails/jsbundling-rails]
gem 'jsbundling-rails'
gem "cssbundling-rails"
#gem 'sprockets-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbo-rails"
gem "stimulus-rails"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'net-http'

gem 'devise'
gem 'devise-jwt'

gem 'mail'

gem 'rolify'
gem "pundit", "~> 2.2"

gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

gem 'concurrent-ruby', '1.3.4'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

group :development, :test do
# See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'capistrano'
  #  gem 'capistrano-yarn'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'capistrano-rbenv'
end

group :test do
  gem "minitest"
  gem "capybara"
  gem "selenium-webdriver"
end