$LOAD_PATH.unshift(File.dirname(__FILE__))

$env = ENV["RACK_ENV"] || "development"

# Basic setup
require 'rubygems'
require 'bundler/setup'

Bundler.require(:default, $env.to_sym)
Dotenv.load if defined?(Dotenv)

# Load Config, Lib & Initializers
require 'config/config'
Dir[File.join(__dir__, 'lib', '**', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'config', 'initializers', '**', '*.rb')].each { |file| require file }

# Bot & API Core
require 'slack-bot/slack_bot'
