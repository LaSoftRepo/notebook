FROM vitalikpaprotsky/repeek-base

COPY . /usr/src/app

RUN gem update bundler
RUN bundle install --path vendor/bundle --without test development
RUN bundle exec rake assets:precompile RAILS_ENV=production
