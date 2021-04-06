module SlackBot
  module RTM
    class Pry < SlackRubyBot::Commands::Base
      help do
        title     'pry'
        desc      'Usage: `[bot] pry` [*Admin only*]'
        long_desc 'Calls binding.pry, only visible in the bot\'s console.'
      end

      command 'pry' do |client, data, match|
        begin
          binding.pry
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
