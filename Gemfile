source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.0'

# for building json apis
gem 'jbuilder', '~> 2.5'

# for generating api docs
gem 'apipie-rails', '~> 0.3.6'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'rubocop', require: false
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# causes errors on older versions of bundler (<=1.3.5?)
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# fix for fedora: <https://github.com/rails/rails/issues/25676>
gem 'json', '~> 1.8.3'
