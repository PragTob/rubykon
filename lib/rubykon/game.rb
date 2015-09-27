module Rubykon
  class Game
    attr_reader :moves, :board, :group_overseer
    attr_accessor :komi

    DEFAULT_KOMI = 6.5

    # the freakish constructor is here so that we can have a decent dup
    def initialize(size = 19, komi = DEFAULT_KOMI, board = Board.new(size), move_validator = MoveValidator.new, moves = [])
      @board           = board
      @move_validator = move_validator
      @moves          = moves
      @komi           = komi
      @group_overseer = GroupOverseer.new
    end

    def play(x, y, color)
      identifier = @board.identifier_for(x, y)
      if valid_move?(identifier, color)
        set_valid_move(identifier, color)
        true
      else
        false
      end
    end

    def play!(x, y, color)
      raise IllegalMoveException unless play(x, y, color)
    end

    def move_count
      @moves.size
    end

    def no_moves_played?
      @moves.empty?
    end

    def next_turn_color
      move_count.even? ? Board::BLACK : Board::WHITE
    end

    def finished?
      @moves.size >= 2 && Game.pass?(@moves[-1]) && Game.pass?(@moves[-2])
    end

    def self.from(string)
      game = new(string.index("\n"))
      Board.each_move_from(string) do |identifier, color|
        game.safe_set_move(identifier, color)
      end
      game
    end

    def set_valid_move(identifier, color)
      @moves << identifier
      unless Game.pass?(identifier)
        @board[identifier] = color
        @group_overseer.assign(identifier, color, board)
      end
    end

    def safe_set_move(identifier, color)
      return if color == Board::EMPTY
      set_valid_move(identifier, color)
    end

    def dup
      self.class.new @size, @komi, @board.dup, @move_validator, @moves.dup
    end

    def self.other_color(color)
      if color == :black
        :white
      else
        :black
      end
    end

    def self.pass?(identifier)
      identifier.nil?
    end

    private
    def valid_move?(identifier, color)
      @move_validator.valid?(identifier, color, self)
    end
  end
end