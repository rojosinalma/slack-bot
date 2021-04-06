require_relative 'version'

module SlackRubyBot
  git_sha = `git rev-parse HEAD`

  ABOUT = <<~ABOUT.freeze
    slack-bot app version: `#{::SlackBot::VERSION}`
    slack-ruby-bot gem version: `#{SlackRubyBot::VERSION}`
    current git sha: `#{git_sha.gsub("\n", "")}`
  ABOUT
end
