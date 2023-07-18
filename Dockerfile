FROM ruby:3.2.2-alpine3.18

RUN apk add --no-cache \
  build-base \
  postgresql-dev \
  postgresql-client \
  nodejs \
  yarn \
  tzdata

RUN gem install bundler:2.4.14

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 20 --retry 5

COPY . .

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]