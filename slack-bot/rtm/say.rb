module SlackBot
  module RTM
    class Say < SlackRubyBot::Commands::Base
      help do
        title     'say'
        desc      'Usage: `[bot] say #channel <message>` [*Admin only*]'
        long_desc 'Says something as the bot in `#channel`.'
      end

      command 'say' do |client, data, match|
        args           = match[:expression].split(" ")
        target_channel = args.shift
        begin
          client.say(
            channel: Helpers::SlackHelper.to_id(target_channel),
            text: args.join(" ")
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
