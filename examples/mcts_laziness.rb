require_relative '../lib/mcts'
require_relative '../lib/mcts/examples/double_step'

double_step_game = MCTS::Examples::DoubleStep.new
mcts = MCTS::MCTS.new


[10, 100, 1000].each do |playouts|
  results = Hash.new {0}
  100.times do
    root = mcts.start double_step_game, playouts
    best_move = root.best_move
    results[best_move] += 1
  end
  puts "Distribution for #{playouts} playouts: #{results}"
end
