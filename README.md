Slack Bot
--

Slack bot skelleton.

### Requirements:

* Ruby 2.6
* Make 3.8
* Docker 19.03

### Docker setup:
_Assuming you already have Make and Docker installed_

1. Clone it
2. Rename the `.env.example` file into `.env` and add the env vars accordingly.

* `make dev` will build the image open a terminal inside it.
* `make build` will (re)build a fresh version of the image.


### Local Setup:
_Assuming you have Ruby 2.6 and Bundler installed_

1. Clone it
2. Rename the `.env.example` file into `.env` and add the env vars accordingly.
3. `cd slack-bot`
4. `bundle install`
5. `foreman start`
6. Be the superhero people need you to be.

If you want to start the bot normally, you can do so with `foreman start`. This way the bot will start a client with the RTM API **and** set up endpoints for Web API interactions (see [How do Slack Apps work?](#how-do-slack-apps-work-or-wtf-is-slack-doing-with-so-many-apis) below for more info).

+ The RTM API allows the bot to respond to text-based commands and interact with users in real time. i.e: `bot hi`

+ The Web API endpoints allows the usage of slash-commands and other interactions via Slack's Web API.

You don't need both at the same time, if you want to start the Bot without one of the previous mentioned setups you can prepend the following options:

+ `NORTM=true` will ignore the bootstrap of the RTM API.

+ `NOWEB=true` will ignore setting up the endpoints for the Web API.


### Development Notes:

**About Tokens:**

+ The SLACK_API_TOKEN is the token used to connect to the RTM API (a.k.a bot token).

+ The SLACK_WEB_TOKEN is used only in cases when we need to interact with the Web API (a.k.a user token).

Don't hate the names of the variables, hate Slack's spaghetti API structure. You can find more info about tokens [here](https://api.slack.com/docs/token-types).

**About Files:**

+ The `config.ru` file is the first one to be loaded and contains everything that this app needs to bootstrap (think about it as the big bang), gems, external libraries, additional tools for the project, etc. Since it's the main bootstrap file, this file should be where you determine the general boot/load order.

+ The `slack-bot/slack-bot.rb` is the second most important file in the boot order, it loads everything related specifically to both the custom developed Bot and it's API. This is meant to be the main entrypoint for loading modules and classes.

+ The `slack-bot/rtm.rb` file starts a Bot using the RTM Slack API, meaning it's for bot interactions in real time via chat.

+ The `slack-bot/web.rb` file starts a simple api made in `sinatra` meant to be used for either health checks or opening up endpoints.

+ New commands can be added in the `slack-bot/rtm_api/` folder, by creating a new file with the name of the command i.e: `slack-bot/rtm/ping.rb`.

+ New endpoints should go inside the `slack-bot/web/endpoints.rb` file.

+ The `utils` folder is for general utilities. The `slack-bot/utils/slack_helpers.rb` file is an example of this and contains various mixins and helper methods that may be used across multiple RTM commands or Web API endpoints.

**About the gems:**

+ If you need more information or guidance of how the `slack-ruby-bot` gem works, check the [slack-ruby-bot](https://github.com/slack-ruby/slack-ruby-bot) gem docs.

+ Also, the `slack-ruby-bot` gem uses the [slack-ruby-client](https://github.com/slack-ruby/slack-ruby-client) gem, which is the one that really connects to all the APIs and allows the bot gem to interact with them. You might wanna check that too.

### How do Slack Apps work? (or WTF is Slack doing with so many APIs):

If all of this sounds super confusing, it's because Slack's API structure is FUBAR. In an attempt to explain it, read next:

Slack is currently composed of 3 core APIs that are available to all Slack Apps (there is a 4th one, but it's more of an extension of the Web API than an independent API).

1. **[Real Time Messages (RTM)](https://api.slack.com/rtm):**

    This API is based on websockets and pushes different events that are related to texts/actions that occur inside Slack (like when somebody is typing, a regular text message that triggers a command, somebody reacted with an emoji, etc). The bot opens a websocket with the provided token to Slack and as long as this websocket stays open, the bot will "listen" to all events, but will only act on those that are defined as commands.

    Currently this is the main way to interact with the bot. When you text `bot hi`, the bot will "listen" to the text and if there's some command implemented to react, it will do something. i.e: it can send a text back, create a channel, PM someone, etc.

    This API is available in the `client` variable when you create a command. Since this API is mainly used for the bot to receive messages, not all actions of the Bot are available through this `client`. Creating channels , for example, depends on the Web API (read below).

2. **[The Web API (REST-like API):](https://api.slack.com/web)**

    This API works like any other REST API, you pass a token to allow the bot to call different endpoints in the Slack API and do different things, i.e: Creating channels, texting people, reacting with emojis, etc.

    Combining this with the RTM API is what really gives the Bot the power to do almost everything in Slack, the only limitation is the scopes that are set up in the Slack App. These scopes determine which parts of the API are usable with the token.

    This is available in commands through the `web_client` in both commands and endpoints.

3. **[Events API (a.k.a Pub/Sub):](https://api.slack.com/events-api)**

    To set it up you point the name of a command and a callback URL, then inside Slack you call the command and Slack posts a payload with it's parameters to the callback URL you provided. It's expected that the bot also subscribes to the URL you gave in order to get the events, this subscription logic is of course part of the Bot itself and not of Slack.

    It's very similar to the Web API, with the difference that this establishes a subscription to the callback URL and constantly listens to events determined in the Slack App.

4. **[Conversations API:](https://api.slack.com/docs/conversations-api)**

    We don't use this one and it's not relevant to this bot, so it won't be documented, but consider doing so if at any point this becomes part of the code.

For more information of the details and differences, you can read the official [Slack Docs](https://api.slack.com/start/planning/choosing).

---

If you have even more questions about the bot, the gems or the APIs, try asking around in Slack servers dedicated to bot development. [Bot Developer Hangout](https://community.botkit.ai/) is a pretty good one.
