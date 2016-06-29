FROM ruby:2.3.0
ENV LANG C.UTF-8
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm nodejs-legacy
RUN npm install -g phantomjs-prebuilt
RUN gem install bundler

ENV APP_HOME /a-know-home
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install
