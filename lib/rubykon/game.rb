module Rubykon
  class Game
    attr_reader :board, :group_tracker, :move_count
    attr_accessor :komi

    DEFAULT_KOMI = 6.5

    # the freakish constructor is here so that we can have a decent dup
    def initialize(size = 19, komi = DEFAULT_KOMI, board = Board.new(size),
                   move_count = 0, consecutive_passes = 0,
                   move_validator = MoveValidator.new,
                   group_tracker = GroupTracker.new)
      @board              = board
      @move_validator     = move_validator
      @move_count         = move_count
      @consecutive_passes = consecutive_passes
      @komi               = komi
      @group_tracker      = group_tracker
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

    def no_moves_played?
      @move_count == 0
    end

    def next_turn_color
      move_count.even? ? Board::BLACK : Board::WHITE
    end

    def finished?
      @consecutive_passes >= 2
    end

    def self.from(string)
      game = new(string.index("\n"))
      Board.each_move_from(string) do |identifier, color|
        game.safe_set_move(identifier, color)
      end
      game
    end

    def set_valid_move(identifier, color)
      # print [identifier, color].inspect
      @move_count += 1
      if Game.pass?(identifier)
        @consecutive_passes += 1
      else
        set_move(color, identifier)
      end
    end

    def safe_set_move(identifier, color)
      return if color == Board::EMPTY
      set_valid_move(identifier, color)
    end

    def dup
      self.class.new @size, @komi, @board.dup, @move_count, @consecutive_passes,
                     @move_validator, @group_tracker.dup
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

    def set_move(color, identifier)
      @board[identifier] = color
      @group_tracker.assign(identifier, color, board)
      @consecutive_passes = 0
    end
  end
end