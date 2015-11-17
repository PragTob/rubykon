# Rubykon [![Gem Version](https://badge.fury.io/rb/rubykon.svg)](https://badge.fury.io/rb/rubykon)[![Build Status](https://secure.travis-ci.org/PragTob/rubykon.png?branch=master)](https://travis-ci.org/PragTob/rubykon)[![Code Climate](https://codeclimate.com/github/PragTob/Rubykon.png)](https://codeclimate.com/github/PragTob/Rubykon)[![Test Coverage](https://codeclimate.com/github/PragTob/Rubykon/badges/coverage.svg)](https://codeclimate.com/github/PragTob/Rubykon/coverage)
A Go-Engine being built in Ruby. 

### Status?
There is a CLI with which you can play, it does a full UCT MCTS. Still work to do on making move generation and scoring faster. Also there is no AMAF/RAVE implementation yet (which would make it a lot stronger) and it also does not use any expert knowledge right now. So still a lot to do, but it works.


### Sub gems
Right now the `mcts` and `benchmark/avg` gem that I wrote for this are still embedded in here. They are bound to be broken out and released as separate gems to play with. If you want to use them now, just use rubykon and you can require `mcts` or `benchmark/avg` :)

### Why would you build a Go-Bot in Ruby?
Cause it's fun.

### Running truffle

Go ahead and [install from source](https://github.com/jruby/jruby/wiki/Truffle#from-source). Then you have to specify the graal VM when you execute something like this:

    JAVACMD=~/dev/graalvm-jdk1.8.0/bin/java ../jruby/bin/jruby -X+T -e 'puts Truffle.graal?'
    
If this (adjusted to your paths) prints `true` then the setup is good so far.
 
Next up, install the jruby+truffle tool. Go into the jruby directory you checked out and make sure you use the same ruby version/gemset you want to use (this installs a gem). Then do:
 
    tool/jt.rb install-tool
    
With this installed you can then setup graal in your repository (i.e. rubykon), this install gems etc.:

    jruby+truffle setup
    
This should now still print true:

    jruby+truffle --graal-path ../graalvm-jdk1.8.0/bin/java run --graal -- -e 'p Truffle.graal?'
    
You can then use it like this to run benchmarks et. al.:

    jruby+truffle --graal-path ../graalvm-jdk1.8.0/bin/java run --graal -J-Xmx1500m benchmark/mcts.rb
    
The `-J-Xmx1500m` is important as truffle needs more heap space.
    
You can also run the specs via `jruby+truffle run -S rspec spec/`
