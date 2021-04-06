# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Core
gem 'dotenv'
gem 'puma'
gem 'sinatra'
gem 'slack-ruby-bot'
gem 'async-websocket', '~> 0.8.0'

# Tools
gem 'concurrent-ruby', require: 'concurrent'
gem 'http'
gem 'GiphyClient'
gem 'rake'

group :development, :test do
  gem 'pry-byebug'
  gem 'foreman'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'factory_bot'
end
