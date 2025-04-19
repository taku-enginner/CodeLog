#!/bin/bash
set -e

# DBの起動待ち
until pg_isready -h db -U postgres; do
  echo "Waiting for postgres..."
  sleep 1
done

bundle install
bundle exec rails db:prepare
rm -f tmp/pids/server.pid

exec "$@"