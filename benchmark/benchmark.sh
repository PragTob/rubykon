#! /bin/bash --login

script_name=$1

# declare -a RUBIES=( "2.0.0-p648" "2.4.1" "jruby-9.1.9.0" )
#
# for ruby in "${RUBIES[@]}"
# do
#   echo Running $ruby
#   asdf local ruby $ruby
#   ruby -v
#   ruby $script_name
#   echo
#   echo
# done
#
# declare -a JRUBIES=("jruby-9.1.9.0" )
# for ruby in "${JRUBIES[@]}"
# do
#   echo Running $ruby with --server -Xcompile.invokedynamic=true -J-Xmx1500m
#   asdf local $ruby
#   ruby -v
#   ruby --server -Xcompile.invokedynamic=true -J-Xmx1500m $script_name
#   echo
#   echo
# done
#
# asdf local ruby 2.4.1

echo Running Ruby 2.0 as a base line
asdf local ruby 2.0.0-p648
ruby -v
ruby $script_name

echo
echo ----------------------------------------------
echo

echo Running truffle from graalvm 25
~/dev/graalvm-0.25/bin/ruby -v
~/dev/graalvm-0.25/bin/ruby -J-Xmx1500m $script_name

echo
echo -------------------------------------
echo

echo Running truffle from graalvm 27
~/dev/graalvm-0.27/bin/ruby -v
~/dev/graalvm-0.27/bin/ruby -J-Xmx1500m $script_name

echo
echo -------------------------------------
echo

echo Running mjit ruby without the mjit latest commit 25th of August

/usr/local/bin/ruby -v
/usr/local/bin/ruby $script_name

echo
echo -------------------------------------
echo

echo Running mjit with MJIT enabled latest commit 25th of August

/usr/local/bin/ruby -v
/usr/local/bin/ruby -j $script_name
