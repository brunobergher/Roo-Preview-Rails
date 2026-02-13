source "https://rubygems.org"

ruby "3.3.7"

gem "rails", "~> 8.0"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"
gem "sprockets-rails"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", "~> 5.0"
gem "connection_pool", "~> 2.4"
gem "sidekiq", "~> 7.2"
gem "bootsnap", require: false
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "tailwindcss-rails", "~> 4.4"

gem "rack-cors", "~> 3.0"

gem "sinatra", "~> 4.0"
