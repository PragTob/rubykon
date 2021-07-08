module MCTS
  class Node
    attr_reader :parent, :move, :wins, :visits, :children, :game_state

    def initialize(game_state, move, parent)
      @parent        = parent
      @game_state    = game_state
      @move          = move
      @wins          = 0.0
      @visits        = 0
      @children      = []
      @untried_moves = game_state.all_valid_moves
      @leaf          = game_state.finished? || @untried_moves.empty?
    end

    def uct_value
      win_percentage + UCT_BIAS_FACTOR * Math.sqrt(Math.log(parent.visits)/@visits)
    end

    def win_percentage
      @wins/@visits
    end

    def root?
      false
    end

    def leaf?
      @leaf
    end

    def uct_select_child
      children.max_by &:uct_value
    end

    # maybe get a maximum depth or soemthing in
    def expand
      move = @untried_moves.pop
      create_child(move)
    end

    def rollout
      state = @game_state.dup
      state.set_move(state.generate_move) until state.finished?
      state.winner
    end

    def backpropagate(winner:)
      node = self
      node.update_stats(winner: winner) until (node = node.parent).nil?
    end

    def untried_moves?
      !@untried_moves.empty?
    end

    def update_stats(winner:)
      @visits += 1
      @wins += 1 if winner == acting_player
    end

    private

    def acting_player
      return -1 if parent.nil?
      game_state.last_turn_color
    end

    def create_child(move)
      game_state = @game_state.dup
      game_state.set_move(move)
      child = Node.new game_state, move, self
      @children << child
      child
    end
  end
end
