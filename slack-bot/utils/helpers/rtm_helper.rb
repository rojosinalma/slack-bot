module SlackBot
  module Helpers
    module RTMHelper
      class << self
        def done(client, data, match)
          client.say(
            channel: data.channel,
            text: "Done :v:",
            thread_ts: data.thread_ts || data.ts
          )
        end

        def not_able(client, data, match, error)
          client.say(
            channel: data.channel,
            text: "Sorry, I wasn't able to do that :see_no_evil:\n Error:\n ```\n#{error&.message}\n```",
            thread_ts: data.thread_ts || data.ts
          )
        end

        # It combines users from the "Admins" group in Slack (if any) with the ones passed in the ENV var.
        def permitted?(client, data, match)
          slack_admins = admins_from_slack
          env_admins   = SlackBot.config[:admin_ids]
          admin_ids    = slack_admins + env_admins

          if admin_ids.include?(data&.user)
            return true
          else
            client.say(
              channel:   data.channel,
              text:      "You are not an admin :hear_no_evil:",
              thread_ts: data.thread_ts || data.ts
            )

            return false
          end
        end

        # Tries to find a group called "Admins"
        # If so, it uses the usergroup ID and searches for the users in that group.
        # Otherwise just return []
        def admins_from_slack
          slack_usergroups = web_client.usergroups_list['usergroups']
          results          =  if slack_usergroups.empty?
                                []
                              else
                                slack_usergroups.select{|groups| groups['name'] == "Admins"}
                              end

          unless results.empty?
            return web_client.usergroups_users_list(usergroup: results.first['id'] )["users"]
          else
            return []
          end
        end

        # Some Web API methods (like `channels.create`) **need** to use an "OAuth Access Token" (OAT), which is not the same as the "Bot User OAuth Access Token" (BUOAT)
        # The BUOAT is for all RTM API related matters and, using a BUOAT with the Web API will fail with "not_allowed_token_type",
        # because you need to use an OAT instead, this is because the two tokens have different properties and scopes (i.e: an OAT can't access the rtm:stream scope)
        # So because of Slack's unwillingness to allow one token to interact with both APIs (honestly Slack... wtf)
        # The only solution (as per of this comment) is to create a new Web Client when necessary, hence this helper method:
        def web_client
          web_client ||= ::Slack::Web::Client.new(token: SlackBot.config[:slack_web_token])
        end
      end
    end
  end
end
