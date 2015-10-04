module MCTS
  class MCTS
    def start(game_state, playouts = DEFAULT_PLAYOUTS)
      root = Root.new(game_state)
      own_color = game_state.next_turn_color

      playouts.times do
        explore_tree(root, own_color)
      end

      best_node = root.best_child
      best_node.move
    end
  end
end

