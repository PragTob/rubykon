module MCTS
  class Root < Node
    def initialize(game_state)
      super game_state, nil, nil
    end

    def root?
      true
    end

    def best_child
      children.max_by &:win_percentage
    end

    def best_move
      best_child.move
    end

    def explore_tree
      node = select
      node = node.expand unless node.leaf?
      winner = node.rollout
      node.backpropagate(winner: winner)
    end

    private
    def select
      node = self
      until node.untried_moves? || node.leaf? do
        node = node.uct_select_child
      end
      node
    end
  end
end
