#! /bin/bash --login

array=( 2.2 jruby rbx jruby-1 jruby-dev-graal 1.9.3 )

for ruby in "${array[@]}"
do
  echo $ruby
  rvm use $ruby
  ruby benchmark/full_playout.rb
done

