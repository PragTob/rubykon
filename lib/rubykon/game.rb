module Rubykon
  class Game
    attr_reader :moves, :board

    def initialize(size = 19)
      @board = Board.new(size)
      @move_validator = MoveValidator.new
      @moves          = []
    end

    def play(stone)
      if @move_validator.valid?(stone, self)
        @board[stone.x, stone.y] = stone
        @moves << stone
        Group.assign(stone, @board)
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