FROM ruby:3.4-alpine

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["tail", "-f", "/dev/null"]