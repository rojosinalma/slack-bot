SlackRubyBot.configure do |config|
  config.send_gifs = false
end

SlackRubyBot::Client::logger.level = SlackBot.config[:bot_log_level] || 0
