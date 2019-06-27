#!/bin/bash --login
declare -a RUBIES=( "2.4.6" "2.6.3" "2.7.0-dev" "jruby-9.1.17.0" "jruby-9.2.7.0" "truffleruby-19.0.0" "truffleruby-1.0.0-rc16")

for ruby in "${RUBIES[@]}"
do
  echo Running $ruby
  asdf install ruby $ruby
  asdf local ruby $ruby
  ruby -v
  # # new rbx versions crash with new bundler so gotta use the bundled 1.11.x
  # # https://github.com/rubinius/rubinius/issues/3710
  # if [ "$ruby" != "rbx-3.69" ]
  # then
  #   gem install bundler
  # fi
  gem install bundler
  bundle install
  bundle exec rspec
  echo
  echo
done
