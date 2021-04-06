Dir[File.join(__dir__, 'web', '*.rb')].each { |file| require file }

module SlackBot
  module Web
    class Base < Sinatra::Base
      configure :production, :development do
        enable :logging
      end

      helpers Helpers::WebHelper
      use     SlackBot::Web::Endpoints

      get '/' do
        'I\'m alive!'
      end

      not_found do
        404
      end
    end
  end
end
