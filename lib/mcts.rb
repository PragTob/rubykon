require_relative 'mcts/node'
require_relative 'mcts/root_node'
require_relative 'mcts/playout'
require_relative 'mcts/mcts'

module MCTS
  UCT_BIAS_FACTOR = 2
  DEFAULT_PLAYOUTS = 1000
end


