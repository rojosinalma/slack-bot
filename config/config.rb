require 'yaml'
require 'erb'

module SlackBot
  def self.config
    yaml_contents = File.open('config/config.yml').read
    @config     ||= YAML.load( ERB.new(yaml_contents).result )[$env]
    @config.with_indifferent_access
  end
end
