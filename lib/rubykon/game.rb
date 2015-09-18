module Rubykon
  class Game
    attr_reader :moves, :board

    def initialize(size = 19)
      @board = Board.new(size)
      @move_validator = MoveValidator.new
      @moves          = []
    end

    def play(move)
      if @move_validator.validate(move, self)
        @board[move.x, move.y] = move
        @moves << move
        true
      else
        false
      end
    end

    def move_count
      @moves.size
    end

    def no_moves_played?
      @moves.empty?
    end

  end
end