#!/bin/bash --login
declare -a RUBIES=( "2.0.0" "2.2.3" "jruby-9.0.3.0" "rbx-2.5.8"
"2.4.0" "jruby-9.1.7.0" "rbx-3.69" )

for ruby in "${RUBIES[@]}"
do
  echo Running $ruby
  rvm use $ruby
  ruby -v
  # new rbx versions crash with new bundler so gotta use the bundled 1.11.x
  # https://github.com/rubinius/rubinius/issues/3710
  if [ "$ruby" != "rbx-3.69" ]
  then
    gem install bundler
  fi
  bundle install
  bundle exec rspec
  echo
  echo
done
