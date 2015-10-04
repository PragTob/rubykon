module MCTS
  class Playout
    def initialize(game_state)
      @game_state = game_state.dup
    end

    def play
      until @game_state.finished?
        @game_state.set_move @game_state.generate_move
      end
      @game_state
    end
  end
end