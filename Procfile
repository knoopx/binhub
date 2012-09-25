web: bundle exec rails server thin -p $PORT -e $RACK_ENV
worker: bundle exec rake binhub:poll RAILS_ENV=$RACK_ENV