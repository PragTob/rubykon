#! /bin/bash --login

script_name=$1

declare -a RUBIES=( "2.0.0" "2.2.3" "jruby-9.0.3.0" "rbx-2.5.8" "2.3.3"
"2.4.0" "jruby-9.1.6.0" "rbx-3.69" )

for ruby in "${RUBIES[@]}"
do
  echo Running $ruby
  rvm use $ruby
  ruby -v
  ruby $script_name
  echo
  echo
done

declare -a JRUBIES=("jruby-9.0.3.0" "jruby-9.1.6.0" )
for ruby in "${JRUBIES[@]}"
do
  echo Running $ruby with --server -Xcompile.invokedynamic=true -J-Xmx1500m
  rvm use $ruby
  ruby -v
  ruby --server -Xcompile.invokedynamic=true -J-Xmx1500m $script_name
  echo
  echo
done

rvm use 2.3.3@rubykon
echo Running old truffle graal with enough heap space
GRAAL_BIN=~/dev/graalvm-jdk1.8.0/bin/java ../old_jruby/tool/jt.rb run --graal -e 'puts Truffle.graal?'
GRAAL_BIN=~/dev/graalvm-jdk1.8.0/bin/java ../old_jruby/tool/jt.rb run --graal -e "puts RUBY_DESCRIPTION"
GRAAL_BIN=~/dev/graalvm-jdk1.8.0/bin/java ../old_jruby/tool/jt.rb run --graal -J-Xmx1500m $script_name
echo
echo

rvm use 2.3.3
echo Running new truffle head
../jruby/bin/jruby-truffle-tool --graal-path ~/dev/graalvm-0.19-dk/bin/java run --graal -- -e 'puts Truffle::Graal.graal?'
../jruby/bin/jruby-truffle-tool --graal-path ~/dev/graalvm-0.19-dk/bin/java run --graal -- -e  'puts RUBY_DESCRIPTION'
../jruby/bin/jruby-truffle-tool --graal-path ~/dev/graalvm-0.19-dk/bin/java run --graal -- -J-Xmx1500m $script_name
