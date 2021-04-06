Dir[File.join(__dir__, 'utils', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'utils', 'helpers', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'utils', 'workers', '*.rb')].each { |file| require file }

require_relative 'web'
require_relative 'rtm'

module SlackBot
  class BotServer < SlackRubyBot::Server
    extend Helpers::WebHelper

    @@user_msg_info = Hash.new { |h,k| h[k] = Hash.new(0) } # Default values for hash and nested keys to 0

    on :hello do |client, data|
      SlackRubyBot::Client.logger.info "@#{client.self.name} is now Live!"
    end

    on 'message' do |client, data|
      if SlackBot.config[:bot_announce_channels].include?(data.channel) # Do this only in relevant channels
        @@user_msg_info[data.user][:count]    += 1
        @@user_msg_info[data.user][:first_msg] = Time.now if @@user_msg_info[data.user][:count] == 1

        # Reset counters if 1 day has passed.
        if 1.day.ago > @@user_msg_info[data.user][:first_msg]
          @@user_msg_info[data.user][:count]     = 0
          @@user_msg_info[data.user][:first_msg] = 0
        end

        # Warn if this is the first message of the day.
        client.web_client.chat_postEphemeral(channel: data.channel, text: help, user: data.user) if @@user_msg_info[data.user][:count] <= 1
      end
    end
  end
end
