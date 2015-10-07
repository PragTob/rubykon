module MCTS
  class Playout

    attr_reader :game_state

    def initialize(game_state)
      @game_state = game_state.dup
    end

    def play
      playout
      @game_state.won?
    end

    def playout
      until @game_state.finished?
        @game_state.set_move @game_state.generate_move
      end
    end
  end
end