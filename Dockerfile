#TODO: FROM <alpine-ruby>

# Install dependencies
RUN set -ex \
    apk update && \
    apk add build-base \
            readline-dev \
    --no-cache \
    --virtual .deps

# Set up working space
WORKDIR /app/
COPY . /app/

# Install gems
RUN bundle install \
    --clean \
    --system \
    --without development test \
    --jobs=8 \
    --retry=3

# Delete dependencies as we don't need them anymore.
RUN set -ex \
    apk del .deps

# Ready for launch...
EXPOSE 3000

# GO!
CMD bundle exec puma -C config/puma.rb
