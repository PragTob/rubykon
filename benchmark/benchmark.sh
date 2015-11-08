#! /bin/bash --login

script_name=$1
echo $script_name

echo Running truffle graal with enough heap space
jruby+truffle run --graal -- -e "puts RUBY_DESCRIPTION"
jruby+truffle run --graal -J-Xmx1500m $script_name
echo
echo

declare -A RUBY_TO_ARG=( ["2.2"]="" [jruby]="" [jruby-9]="--server -Xcompile.invokedynamic=true -J-Xmx1500m" [rbx]="" [jruby-1]="" [1.9.3]="" )

for ruby in "${!RUBY_TO_ARG[@]}"
do
  echo Running $ruby with ${RUBY_TO_ARG[$ruby]}
  rvm use $ruby
  ruby -v
  ruby ${RUBY_TO_ARG[$ruby]} $script_name
  echo
  echo
done

