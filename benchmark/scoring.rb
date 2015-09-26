require_relative '../lib/rubykon'
require 'benchmark/ips'

Benchmark.ips do |benchmark|
  playout = Rubykon::RandomPlayout.new
  game_9 = playout.playout_for Rubykon::Game.new 9
  game_13 = playout.playout_for Rubykon::Game.new 13
  game_19 = playout.playout_for Rubykon::Game.new 19

  benchmark.report '9x9 scoring' do
    playout.score game_9
  end
  benchmark.report '13x13 scoring' do
    playout.score game_13
  end
  benchmark.report '19x19 scoring' do
    playout.score game_19
  end
end