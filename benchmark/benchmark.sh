#! /bin/bash --login

set -e

script_name=$1

# declare -a RUBIES=( "2.4.6" "2.6.3" "2.7.0-dev"  "truffleruby-19.0.0")

# for ruby in "${RUBIES[@]}"
# do
#   echo Running $ruby
#   asdf local ruby $ruby
#   ruby -v
#   ruby $script_name
#   echo
#   echo "--------------------------------------------------"
#   echo
# done

# echo "-------------------------------------------"
# echo "|             DONE WITH NORMAL RUBIES     |"
# echo "-------------------------------------------"

declare -a JRUBIES=("jruby-9.1.17.0" "jruby-9.2.7.0")
declare -a JAVAS=("adoptopenjdk-8.212" "openjdk-12.0.1" "oracle-8.141"  "corretto-8.212" "corretto-11.0.3")

for java in "${JAVAS[@]}"
do
  echo "Using Java $java"
  asdf local java $java
  java -version

  for ruby in "${JRUBIES[@]}"
  do
    asdf local ruby $ruby
    echo Running $ruby
    ruby -v
    ruby $script_name
    echo

    echo Running $ruby with --server -Xcompile.invokedynamic=true -J-Xmx1500m
    ruby --server -Xcompile.invokedynamic=true -J-Xmx1500m $script_name
    echo
    echo "--------------------------------------------------"
    echo
  done
  echo "-"
  echo
  echo
done

# echo "-------------------------------------------"
# echo "|             DONE WITH JRUBIES          |"
# echo "-------------------------------------------"

# declare -a JITRUBIES=( "2.6.3" "2.7.0-dev" )

# for ruby in "${JITRUBIES[@]}"
# do
#   echo Running $ruby
#   asdf local ruby $ruby
#   ruby -v
#   ruby --jit $script_name
#   echo
#   echo "--------------------------------------------------"
#   echo
# done

# echo "-------------------------------------------"
# echo "|             DONE WITH JIT RUBIES          |"
# echo "-------------------------------------------"
