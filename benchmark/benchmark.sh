#! /bin/bash --login

declare -A RUBY_TO_ARG=( ["2.2"]="" [jruby]="" [rbx]="" [jruby-1]="" [jruby-dev-graal]="-X+T -J-Xmx1500m" [1.9.3]="" )

for ruby in "${!RUBY_TO_ARG[@]}"
do
  echo Running $ruby with ${RUBY_TO_ARG[$ruby]}
  rvm use $ruby
  ruby ${RUBY_TO_ARG[$ruby]} benchmark/full_playout.rb
done

