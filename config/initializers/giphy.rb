Giphy.configure do |config|
  config.api_key = SlackBot.config[:giphy_api_key]
  config.rating  = "G"
end
