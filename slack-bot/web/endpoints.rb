module SlackBot
  module Web
    class Endpoints < Sinatra::Base
      helpers Helpers::WebHelper

      before do
        validate_request! # Validating requests are indeed from Slack or replay attacks.
      end

      # Every response must be 200, even if there was an error
      # https://api.slack.com/slash-commands#sending_error_responses
      post '/command' do
        cmd          = params['command']
        arg          = params['text']
        response_url = params[:response_url]

        200
      end

      # This endpoint is called for interactive elements (i,e: forms, buttons, etc), not for slash commands, those have their own endpoint.
      # But a slash command may trigger a dialog that later sends information to this endpoint.
      post '/interactions' do
        payload      = JSON.parse(params['payload']).with_indifferent_access
        response_url = payload[:response_url]
        worker       = Workers::SomeWorker.new(payload) # If you wanna do stuff async.

        200
      end
    end
  end
end
