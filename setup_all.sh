#!/bin/bash --login
declare -a RUBIES=( "2.0.0" "2.2.3" "jruby-9.0.3.0" "rbx-2.5.8" "2.3.3" "2.4
.0-rc1"
"jruby-9.1.6.0" "rbx-3.69" )

for ruby in "${RUBIES[@]}"
do
  echo Running $ruby
  rvm use $ruby
  ruby -v
  gem install bundler
  bundle install
  bundle exec rspec
  echo
  echo
done
