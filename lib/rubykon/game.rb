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
        set_valid_move(stone)
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

    def safe_set_move(stone)
      if stone.color == Board::EMPTY_COLOR
        @board.set stone
      else
        set_valid_move(stone)
      end
    end

    def self.from(string)
      game = new(string.index("\n"))
      Board.each_stone_from(string) do |stone|
        game.safe_set_move(stone)
      end
      game
    end

    def set_valid_move(stone)
      @board.set stone
      @moves << stone
      Group.assign(stone, @board)
    end
  end
end