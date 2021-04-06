require_relative 'boot'

# SlackBot init
Thread.abort_on_exception = true
unless ENV['NORTM']
  Thread.new do
    begin
      SlackBot::RTM::Bot.run
    rescue Exception => e
      STDERR.puts "ERROR: #{e}"
      STDERR.puts e.backtrace
      raise e
    end
  end
end

# SlackBot API init
run SlackBot::Web::Base unless ENV['NOWEB']
