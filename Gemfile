dddsource:dddsource 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.6'
gem 'mysql2', '0.3.18'
gem 'puma', '~> 3.0'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootstrap-sass', '3.3.7'
gem 'font-awesome-rails'
gem 'lazy_high_charts'
gem 'i18n'
gem 'bcrypt',  '3.1.11'
gem 'carrierwave', '1.2.2'
gem 'mini_magick', '4.7.0'
gem 'material_design_lite-sass'
gem 'omniauth-facebook'
gem 'redcarpet', '~> 2.3.0'
gem 'kaminari'
gem 'faker'
gem 'serviceworker-rails'
gem 'webpush'
gem 'whenever', require: false
gem 'jquery-ui-rails'
gem 'gon'
gem 'rouge'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry-rails', '0.3.4'
  gem 'pry-byebug'
end

group :development do
  gem 'better_errors', '2.1.1'
  gem 'binding_of_caller', '0.7.2'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'capybara', '~> 2.15.4'
  gem 'turnip', '2.1.0'
  gem 'poltergeist', '1.6.0'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper', '~> 1.1.0'
  gem 'shoulda-matchers',
    git: 'https://github.com/thoughtbot/shoulda-matchers.git',
    branch: 'rails-5'
  gem 'launchy', '~> 2.4.3'
  gem 'database_cleaner', '1.6.0'
  gem 'rails-controller-testing'
end

group :production do
  gem 'unicorn'
  gem 'fog-aws'
  gem 'mini_racer'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
