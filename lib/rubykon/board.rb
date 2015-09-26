# Board it acts a bit like a giant 2 dimensional array - but one based
# not zero based
module Rubykon
  class Board
    include Enumerable

    BLACK_COLOR = :black
    WHITE_COLOR = :white
    EMPTY_COLOR = nil

    attr_reader :size, :board

    # weird constructor for dup
    def initialize(size, board = initialize_board(size))
      @size  = size
      @board = board
    end

    def each(&block)
      @board.flatten.each &block
    end

    def [](x, y)
      @board[y - 1][x - 1]
    end
    
    def []=(x, y, stone)
      @board[y - 1][x - 1] = stone
    end

    def set(stone)
      self[stone.x, stone.y] = stone
    end

    def neighbours_of(x, y)
      neighbour_coordinates(x, y).inject([]) do |res, (n_x, n_y)|
        res << self[n_x, n_y] if on_board?(n_x, n_y)
        res
      end
    end

    def neighbour_colors_of(x, y)
      neighbours_of(x, y).map &:color
    end

    def diagonal_colors_of(x, y)
      diagonal_coordinates(x, y).inject([]) do |res, (n_x, n_y)|
        res << self[n_x, n_y].color if on_board?(n_x, n_y)
        res
      end
    end

    def on_edge?(x, y)
      (x == 1) || (y == 1) || (x == size) || (y == size)
    end

    def on_board?(x, y)
      (x >= 1) && (y >= 1) && (x <= size) && (y <= size)
    end
    
    COLOR_TO_CHARACTER = {black: 'X', white: 'O', EMPTY_COLOR => '-'}
    CHARACTER_TO_COLOR = COLOR_TO_CHARACTER.invert

    def ==(other_board)
      board == other_board.board
    end

    def to_s
      @board.map do |row|
        row.map do |stone|
          COLOR_TO_CHARACTER[stone.color]
        end.join
      end.join("\n") << "\n"
    end

    def self.from(string)
      new_board = new string.index("\n")
      each_stone_from(string) do |stone|
        new_board.set stone
      end
      new_board
    end

    def self.each_stone_from(string)
      rows = string.split("\n").map &:chars
      each_field(rows) do |character, x, y|
        yield Stone.new(x, y, CHARACTER_TO_COLOR[character])
      end
    end

    def dup
      dupped_board = self.class.new @size, dup_board
      dupped_board.reassign_groups
      dupped_board
    end

    # not my usual slow methods, but this copying is a mess, looking forward
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

    private
    def initialize_board(size)
      @board = Array.new(size) { Array.new(size) }
      self.class.each_field(@board) do |_field, x, y|
        self[x, y] = Stone.new x, y, EMPTY_COLOR
      end
    end

    def neighbour_coordinates(x, y)
      [[x + 1, y], [x, y + 1],
       [x - 1, y], [x, y - 1]]
    end

    def diagonal_coordinates(x, y)
      [[x - 1, y - 1], [x - 1, y + 1], [x + 1, y - 1], [x + 1, y + 1]]
    end

    def dup_board
      @board.map do |row|
        row.map {|cutting_point| cutting_point.dup}
      end
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
