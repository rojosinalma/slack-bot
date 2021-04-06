Dir[File.join(__dir__, 'rtm', '*.rb')].each { |file| require file }

module SlackBot
  module RTM
    class Bot < SlackRubyBot::Bot
      help do
        title 'Slack Bot'
        desc  'Some description'
      end

      # Redifining help text
      command 'help' do |client, data, match|
        command = match[:expression]
        text    = if command.present?
                   SlackRubyBot::Commands::Support::Help.instance.command_full_desc(command)
                 else
                  other_commands_descs = SlackRubyBot::Commands::Support::Help.instance.other_commands_descs.sort
                  <<~TEXT
                    *Commands:*
                    #{other_commands_descs.join("\n")}

                    For getting description of the command use: *help <command>*
                  TEXT
                 end

        client.say(channel: data.channel, text: text)
      end
    end
  end
end
