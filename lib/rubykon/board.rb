# Board it acts a bit like a giant 2 dimensional array - but one based
# not zero based
module Rubykon
  class Board
    include Enumerable

    BLACK = :black
    WHITE = :white
    EMPTY = nil

    attr_reader :size, :board

    # weird constructor for dup
    def initialize(size, board = create_board(size))
      @size  = size
      @board = board
    end

    def each
      @board.each_with_index do |color, identifier|
        yield identifier, color
      end
    end

    def [](identifier)
      @board[identifier]
    end

    def []=(identifier, color)
      @board[identifier] = color
    end

    def neighbours_of(identifier)
      neighbour_coordinates(identifier).inject([]) do |res, identifier|
        res << [identifier, self[identifier]] if on_board?(identifier)
        res
      end
    end

    def neighbour_colors_of(identifier)
      neighbours_of(identifier).map! &:last
    end

    def diagonal_colors_of(identifier)
      diagonal_coordinates(identifier).inject([]) do |res, n_identifier|
        res << self[n_identifier] if on_board?(n_identifier)
        res
      end
    end

    def on_edge?(identifier)
      x, y = x_y_from identifier
      x == 1 || x == size || y == 1 || y == size
    end

    def on_board?(identifier)
      identifier >= 0 && identifier < @board.size
    end
    
    COLOR_TO_CHARACTER = {BLACK => 'X', WHITE => 'O', EMPTY => '-'}
    CHARACTER_TO_COLOR = COLOR_TO_CHARACTER.invert

    def ==(other_board)
      board == other_board.board
    end

    def to_s
      @board.each_slice(@size).map do |row|
        row_chars = row.map do |color|
          COLOR_TO_CHARACTER.fetch(color)
        end
        row_chars.join
      end.join("\n") << "\n"
    end

    def self.from(string)
      new_board = new string.index("\n")
      each_move_from(string) do |index, color|
        new_board[index] = color
      end
      new_board
    end

    def self.each_move_from(string)
      relevant_chars = string.chars.select do |char|
        CHARACTER_TO_COLOR.has_key?(char)
      end
      relevant_chars.each_with_index do |char, index|
        yield index, CHARACTER_TO_COLOR.fetch(char)
      end
    end

    def dup
      self.class.new @size, @board.dup
    end

    MAKE_IT_OUT_OF_BOUNDS = 1000

    def identifier_for(x, y)
      return nil if x.nil? || y.nil?
      x = MAKE_IT_OUT_OF_BOUNDS if x > @size || x < 1
      (y - 1) * @size + (x - 1)
    end

    def x_y_from(identifier)
      x = (identifier % (@size)) + 1
      y = (identifier / (@size)) + 1
      [x, y]
    end

    private

    def create_board(size)
      Array.new(size * size, EMPTY)
    end

    def neighbour_coordinates(identifier)
      x = identifier % size
      if x == 0
        [identifier + 1, identifier + @size, identifier - @size]
      elsif x == @size - 1
        [identifier + @size, identifier - 1, identifier - @size]
      else
        [identifier + 1, identifier + @size,
         identifier - 1, identifier - @size]
      end
    end

    def diagonal_coordinates(identifier)
      x = identifier % size
      if x == 0
        [identifier + 1 - @size, identifier + 1 + @size]
      elsif x == size - 1
        [identifier - 1 - @size, identifier - 1 + @size]
      else
        [identifier - 1 - @size, identifier - 1 + @size,
         identifier + 1 - @size, identifier + 1 + @size]
      end
    end
  end
end
