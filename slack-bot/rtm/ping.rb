module SlackBot
  module RTM
    class Pong < SlackRubyBot::Commands::Base
      help do
        title     'ping'
        desc      'Usage: `[bot] ping`'
        long_desc 'Pongs back and tells you the delay.'
      end

      command 'ping' do |client, data, _match|
        client.say(
          channel: data.channel,
          text: "pong (#{Time.now.minus_with_coercion(Time.at(data['ts'].to_i)).round(2)}s)",
          thread_ts: data.thread_ts || data.ts
        )
      end
    end
  end
end
