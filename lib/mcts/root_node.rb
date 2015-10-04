module MCTS
  class Root < Node
    def initialize(game_state)
      super game_state, nil, nil
    end

    def root?
      true
    end

    def best_child
      children.max_by &:win_average
    end

    def explore_tree(own_color)
      selected_node = select
      new_child = selected_node.expand
      won = new_child.rollout
      new_child.backpropagate(won)
    end

    private
    def select
      node = self
      until node.untried_moves? do
        node.uct_select_child
      end
      node
    end
  end
end