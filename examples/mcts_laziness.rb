require_relative '../lib/mcts'
require_relative '../lib/mcts/examples/double_step'

mcts = MCTS::MCTS.new


[{black: 0, white: 0},
 {black: 1, white: 0}, {black: 2, white: 0}, {black: 3, white: 0},
 {black: 4, white: 0}, {black: 0, white: 1}, {black: 0, white: 2},
 {black: 0, white: 3}, {black: 0, white: 4}].each do |position|
  [100, 1000].each do |playouts|
    results = Hash.new {0}
    double_step_game = MCTS::Examples::DoubleStep.new position
    100.times do |i|
      root = mcts.start double_step_game, playouts
      best_move = root.best_move
      results[best_move] += 1
      if i == 99
        puts "Overall win percentage: #{root.win_percentage}"
        puts "Win percentage with best move played: #{root.children.find{|node| node.move == best_move}.win_percentage}"
        puts '------------'
        ([root] + root.children).each do |n|
          puts n.move
          puts n.wins
          puts n.visits
          puts '-----------'
        end
      end
    end
    puts "Distribution for #{playouts} playouts with a handicap of #{position[:black] - position[:white]}: #{results}"
  end
end
