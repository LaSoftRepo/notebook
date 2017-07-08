#!/bin/bash
bundle exec rake assets:precompile RAILS_ENV=staging
bundle exec rails s -e staging
