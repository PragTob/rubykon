require_relative '../lib/rubykon'
require_relative '../lib/benchmark/avg'

Benchmark.avg do |benchmark|
  game_state_19 = Rubykon::GameState.new Rubykon::Game.new(19)
  game_state_9 = Rubykon::GameState.new Rubykon::Game.new(9)
  mcts = MCTS::MCTS.new

  benchmark.config warmup: 110, time: 100

  benchmark.report "9x9 1_000 iterations" do
   mcts.start game_state_9, 1_000
  end

  benchmark.report "19x19 1_000 iterations" do
    mcts.start game_state_19, 1_000
  end
end