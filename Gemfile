source 'https://rubygems.org'
ruby '2.1.1'

gem 'rails', '4.1.0'
gem 'pg'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'bcrypt', '~> 3.1.7'
gem 'jbuilder', '~> 2.0'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails'
gem 'haml-rails'
gem 'coffee-rails'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'x-editable-rails'
gem 'jquery-datetimepicker-rails'
gem 'mandrill-api'
gem 'remotipart'
gem 'therubyracer'
gem 'less-rails'
gem 'owlcarousel-rails'
gem 'state_machine'
gem 'breadcrumbs_on_rails'
gem 'wicked'
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'dotenv'

#OTP gem
gem 'active_model_otp'

#asset upload
gem 'carrierwave'
gem 'mini_magick'
gem 'fog'
gem 'asset_sync'
gem 'rack-zippy'

#cors request
gem 'rack-cors', :require => 'rack/cors'

#  Pagination
gem 'kaminari'

gem "bugsnag"

gem 'rubyXL'

gem 'geocoder'

# Customer authentication
gem 'devise'
gem 'devise_invitable'

group :development do
  gem 'spring'
  gem 'rails_best_practices'
end

group :development, :test do
  # gem 'debugger'
  gem 'rspec-rails'
end

group :test do
  gem 'sqlite3'
  gem 'ZenTest'
  gem 'autotest-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'selenium-webdriver'
end

group :server do
  gem 'unicorn'
  gem 'foreman'
end

group :test, :development, :staging do
  gem 'faker'
end

group :production, :staging, :demo do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end
