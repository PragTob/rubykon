require_relative '../lib/rubykon'
require 'benchmark'

Benchmark.bmbm do |benchmark|
  game_state_9  = Rubykon::GameState.new Rubykon::Game.new(9)
  game_state_13 = Rubykon::GameState.new Rubykon::Game.new(13)
  game_state_19 = Rubykon::GameState.new Rubykon::Game.new(19)
  mcts = MCTS::MCTS.new
  benchmark.report "1000 9x9 playouts in MCTS" do
    mcts.start(game_state_9, 1_000)
  end
  benchmark.report "1000 13x13 playouts in MCTS" do
    mcts.start(game_state_13, 1_000)
  end
  benchmark.report "1000 19x19 playouts in MCTS" do
    mcts.start(game_state_19, 1_000)
  end
end