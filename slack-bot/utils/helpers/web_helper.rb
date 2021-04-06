module SlackBot
  module Helpers
    module WebHelper
      # https://api.slack.com/docs/verifying-requests-from-slack
      def validate_request!
        timestamp = request.env['HTTP_X_SLACK_REQUEST_TIMESTAMP']
        raw_body  = request.try(:body).try(:string)

        return 401 if raw_body.nil?

        data      = "v0:#{timestamp}:#{raw_body}"
        key       = SlackBot.config[:slack_signing_secret]
        signature = request.env['HTTP_X_SLACK_SIGNATURE']
        hash      = "v0=" + OpenSSL::HMAC.hexdigest("SHA256", key, data)
        return 401 unless (signature == hash) || (Time.now.to_i - timestamp.to_i > 60*5)
      end

      def post_ephemeral_error(response_url, message)
        HTTP.post(response_url, json: {"response_type": "ephemeral", "text": "I wasn't able to do that :sweat:.\nError:\n ```\n#{message}\n```" })
      end

      # def bot_id
      #   web_client.users_info(user: "@<bot_name>").user.id
      # end

      def web_client
        web_client ||= ::Slack::Web::Client.new(token: SlackBot.config[:slack_web_token])
      end

      def help
        "What up"
      end
    end
  end
end
