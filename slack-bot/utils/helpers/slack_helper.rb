module SlackBot
  module Helpers
    module SlackHelper
      def self.to_id(expression)
        (/[\d\w]+/).match(expression).to_s
      end
    end
  end
end
