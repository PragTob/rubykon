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

    def each(&block)
      @board.each_with_index &block
    end

    def [](x, y)
      get(identifier_for(x, y))
    end

    def []=(x, y, color)
      set(identifier_for(x, y), color)
    end

    def set(identifier, color)
      @board[identifier] = color
    end

    def get(identifier)
      @board[identifier]
    end

    def neighbours_of(identifier)
      neighbour_coordinates(identifier).inject([]) do |res, identifier|
        res << get(identifier) if on_board?(identifier)
        res
      end
    end

    def neighbour_colors_of(identifier)
      neighbours_of(identifier)
    end

    def diagonal_colors_of(x, y)
      diagonal_coordinates(x, y).inject([]) do |res, (n_x, n_y)|
        res << self[n_x, n_y].color if on_board?(n_x, n_y)
        res
      end
    end

    def on_edge?(identifier)
      x = identifier % @size
      y = identifier / size
      x == 0 || x == (size - 1) || y == 0 || y == (size - 1)
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
      @board.each_slice(@size) do |row|
        row.map do |color|
          COLOR_TO_CHARACTER[color]
        end.join
      end.join("\n") << "\n"
    end

    def self.from(string)
      new_board = new string.index("\n")
      each_move_from(string) do |index, color|
        new_board.set(index, color)
      end
      string.chars.each_with_index do |char, i|
      end
      new_board
    end

    def self.each_move_from(string)
      rows = string.split("\n").map &:chars
      string.chars.each_with_index do |char, index|
        yield index, CHARACTER_TO_COLOR[char]
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

    def identifier_for(x, y)
      (y - 1) * @size + (x - 1)
    end

    private

    # def x_y_from(identifier)
    #
    # end

    def neighbour_coordinates(identifier)
      [identifier + 1, identifier + @size,
       identifier - 1, identifier - @size]
    end

    def diagonal_coordinates(identifier)
      [identifier - 1 - @size, identifier - 1 + @size,
       identifier + 1 - @size, identifier + 1 + @size]
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
