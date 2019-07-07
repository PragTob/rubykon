#! /bin/bash --login

script_name=$1

declare -a RUBIES=( "2.4.6" "2.6.3" "2.7.0-dev"  "jruby-9.1.17.0" "jruby-9.2.7.0" "truffleruby-19.0.0")

for ruby in "${RUBIES[@]}"
do
  echo Running $ruby
  asdf local ruby $ruby
  ruby -v
  ruby $script_name
  echo
  echo "--------------------------------------------------"
  echo
done

echo "-------------------------------------------"
echo "|             DONE WITH NORMAL RUBIES     |"
echo "-------------------------------------------"


declare -a JRUBIES=("jruby-9.1.17.0" "jruby-9.2.7.0" )
for ruby in "${JRUBIES[@]}"
do
  echo Running $ruby with --server -Xcompile.invokedynamic=true -J-Xmx1500m
  asdf local ruby $ruby
  ruby -v
  ruby --server -Xcompile.invokedynamic=true -J-Xmx1500m $script_name
  echo
  echo "--------------------------------------------------"
  echo
done

echo "-------------------------------------------"
echo "|             DONE WITH ID RUBIES          |"
echo "-------------------------------------------"

declare -a JITRUBIES=( "2.6.3" "2.7.0-dev" )

for ruby in "${JITRUBIES[@]}"
do
  echo Running $ruby
  asdf local ruby $ruby
  ruby -v
  ruby --jit $script_name
  echo
  echo "--------------------------------------------------"
  echo
done

echo "-------------------------------------------"
echo "|             DONE WITH JIT RUBIES          |"
echo "-------------------------------------------"