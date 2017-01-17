require_relative '../lib/rubykon'
require_relative '../lib/benchmark/avg'

Benchmark.avg do |benchmark|
  game_state_9 = Rubykon::GameState.new Rubykon::Game.new(9)
  game_state_13 = Rubykon::GameState.new Rubykon::Game.new(13)
  game_state_19 = Rubykon::GameState.new Rubykon::Game.new(19)
  mcts = MCTS::MCTS.new

  benchmark.config warmup: 180, time: 180

  # benchmark.report "9x9 10_000 iterations" do
  #   mcts.start game_state_9, 10_000
  # end
  #
  # benchmark.report "13x13 2_000 iterations" do
  #   mcts.start game_state_13, 2_000
  # end

  benchmark.report "19x19 1_000 iterations" do
    mcts.start game_state_19, 1_000
  end
end
