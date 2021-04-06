module SlackBot
  module Workers
    class SomeWorker
      include Helpers::WebHelper
      include Concurrent::Async

      def initialize(payload)
        super() # Because Concurrent::Async # http://ruby-concurrency.github.io/concurrent-ruby/master/Concurrent/Async.html
        @payload            = payload
        @submitting_user_id = payload[:user][:id]
        @submission         = payload[:submission]
      end

      def some_async_method
      end
    end
  end
end
