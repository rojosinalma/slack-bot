module SlackBot
  module RTM
    class ArchiveChannel < SlackRubyBot::Commands::Base
      help do
        title     'archive channel'
        desc      'Usage: `[bot] archive channel #channel` [*Admin only*]'
        long_desc 'Archives `#channel`.'
      end

      command 'archive channel' do |client, data, match|
        web_client = Helpers::RTMHelper.web_client # Read the comment for this helper method to understand why we need this.

        begin
          web_client.channels_archive(channel: Helpers::SlackHelper.to_id(match[:expression]))
          Helpers::RTMHelper.done(client, data, match)
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
