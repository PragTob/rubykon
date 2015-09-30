require_relative '../lib/rubykon'
require 'benchmark/ips'

Benchmark.ips do |benchmark|
  benchmark.config time: 30, warmup: 60
  
  game_9 = Rubykon::Game.new 9
  game_13 = Rubykon::Game.new 13
  game_19 = Rubykon::Game.new 19
  playout = Rubykon::RandomPlayout.new

  benchmark.report '9x9 playout' do
    playout.playout_for game_9
  end
  benchmark.report '13x13 playout' do
    playout.playout_for game_13
  end
  benchmark.report '19x19 playout' do
    playout.playout_for game_19
  end
end