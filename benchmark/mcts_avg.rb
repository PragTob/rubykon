require_relative '../lib/rubykon'
require_relative '../lib/benchmark/avg'

Benchmark.avg do |benchmark|
  game_state_19 = Rubykon::GameState.new Rubykon::Game.new(19)
  mcts = MCTS::MCTS.new

  benchmark.config warmup: 120, time: 180

  benchmark.report "19x19 1_000 iterations" do
    mcts.start game_state_19, 1_000
  end
end
