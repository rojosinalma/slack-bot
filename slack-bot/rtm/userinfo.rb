module SlackBot
  module RTM
    class UserInfo < SlackRubyBot::Commands::Base
      help do
        title     'userinfo'
        desc      'Usage: `[bot] userinfo @username` [*Admin only*]'
        long_desc 'Gives debug info about a `@username`.'
      end

      command 'userinfo' do |client, data, match|
        begin
          user_id   = Helpers::SlackHelper.to_id(match[:expression])
          user      = client.web_client.users_info(user: user_id).try('user')
          user_info = "```\n#{user}\n```"

          client.say(
            channel: data.channel,
            text: user_info,
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
