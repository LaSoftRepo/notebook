FROM vitalikpaprotsky/repeek-base

COPY . /usr/src/app

RUN gem update bundler
RUN bundle install
