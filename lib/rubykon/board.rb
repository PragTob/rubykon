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
    def initialize(size)
      @size  = size
      @board = Array.new(size * size, EMPTY)
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
      dupped_board = self.class.new @size, dup_board
      dupped_board.reassign_groups
      dupped_board
    end

    # not my usual short methods, but this copying is a mess, looking forward
    # to throwing it away somehow and replacing it with simple data structures
    # straight on board/game
    def reassign_groups
      groups = map(&:group).compact!.uniq!
      return if groups.nil?
      groups.each do |original_group|
        group_dup = original_group.dup
        original_group.stones.each do |stone|
          new_stone = self[stone.x, stone.y]
          new_stone.join(group_dup)
          group_dup.stones << new_stone
        end
        original_group.liberties.each do |identifier, stone|
          group_dup.liberties[identifier] = self[stone.x, stone.y]
        end
      end
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

    def dup_board
      @board.dup
    end

    def self.each_field(enumerable)
      enumerable.each_with_index do |row, y|
        row.each_with_index do |field, x|
          yield field, x + 1, y + 1
        end
      end
    end
  end
end
