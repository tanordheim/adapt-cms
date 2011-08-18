FROM ruby:1.9

RUN apt-get update \
    && apt-get -y install \
         vim \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app

COPY Gemfile* /app
RUN bundle install

COPY . /app/
