#!/bin/bash
bin/rake assets:precompile RAILS_ENV=staging
bin/rails s -e staging
