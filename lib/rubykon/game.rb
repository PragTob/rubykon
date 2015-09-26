module Rubykon
  class Game
    attr_reader :moves, :board
    attr_accessor :komi

    DEFAULT_KOMI = 6.5

    def initialize(size = 19, komi = DEFAULT_KOMI)
      @board = Board.new(size)
      @move_validator = MoveValidator.new
      @moves          = []
      @komi           = komi
    end

    def play(stone)
      if valid_move?(stone)
        set_valid_move(stone)
        true
      else
        false
      end
    end

    def play!(stone)
      if valid_move?(stone)
        set_valid_move(stone)
      else
        raise IllegalMoveException.new
      end
    end

    def move_count
      @moves.size
    end

    def no_moves_played?
      @moves.empty?
    end

    def next_turn_color
      move_count.even? ? Board::BLACK_COLOR : Board::WHITE_COLOR
    end

    def finished?
      @moves.size >= 2 && @moves[-1].pass? && @moves[-2].pass?
    end

    def self.from(string)
      game = new(string.index("\n"))
      Board.each_stone_from(string) do |stone|
        game.safe_set_move(stone)
      end
      game
    end

    def set_valid_move(stone)
      @moves << stone
      unless stone.pass?
        @board.set stone
        Group.assign(stone, @board)
      end
    end

    def safe_set_move(stone)
      if stone.color == Board::EMPTY_COLOR
        @board.set stone
      else
        set_valid_move(stone)
      end
    end

    private
    def valid_move?(stone)
      @move_validator.valid?(stone, self)
    end
  end
end