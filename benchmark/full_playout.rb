require_relative '../lib/rubykon'

def truffle? # truffle can't do gem install
  defined?(RUBY_DESCRIPTION) && RUBY_DESCRIPTION.match(/graal/)
end

if truffle?
  embedded_path = File.expand_path('benchmark-ips/lib/', File.dirname(__FILE__))
  $LOAD_PATH << embedded_path
end

require 'benchmark/ips'

Benchmark.ips do |benchmark|
  benchmark.config time: 20, warmup: 5

  game_9 = Rubykon::Game.new 9
  game_13 = Rubykon::Game.new 13
  game_19 = Rubykon::Game.new 19
  playout = Rubykon::RandomPlayout.new

  benchmark.report '9x9 full playout (+ score)' do
    playout.play game_9
  end
  benchmark.report '13x13 full playout (+ score)' do
    playout.play game_13
  end
  benchmark.report '19x19 full playout (+ score)' do
    playout.play game_19
  end
end