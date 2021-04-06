module SlackBot
  module RTM
    class ChannelInfo < SlackRubyBot::Commands::Base
      help do
        title     'channelinfo'
        desc      'Usage: `[bot] channelinfo #channel` [*Admin only*]'
        long_desc 'Gives debug info about `#channel`.'
      end

      command 'channelinfo' do |client, data, match|
        begin
          channel_id   = Helpers::SlackHelper.to_id(match[:expression])
          channel      = client.web_client.channels_info(channel: channel_id).try('channel')
          channel_info = "```\n#{channel}\n```"

          client.say(
            channel: data.channel,
            text: channel_info,
            thread_ts: data.thread_ts || data.ts
          )
        rescue => error
          Helpers::RTMHelper.not_able(client, data, match, error)
        end
      end

      def self.permitted?(client, data, match)
        Helpers::RTMHelper.permitted?(client, data, match)
      end
    end
  end
end
