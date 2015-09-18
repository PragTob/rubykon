# Board itself acts a bit like a giant 2 dimensional array - but one based
# not zero based
module Rubykon
  class Board
    include Enumerable
    
    EMPTY_SYMBOL = nil
    
    attr_reader :size, :board
    
    def initialize(size)
      @size           = size
      @board = Array.new(@size) {Array.new @size}
    end
    
    def each(&block)
      @board.flatten.each &block
    end
    
    def [](x,y)
      @board[y - 1][x - 1]
    end
    
    def []=(x, y, stone)
      @board[y - 1][x - 1] = stone
    end
    
    COLOR_TO_CHARACTER = {black: 'X', white: 'O', EMPTY_SYMBOL => '-'}

    def ==(other_board)
      board == other_board.board
    end

    def to_s
      @board.map do |row|
        row.map do |color|
          COLOR_TO_CHARACTER[color]
        end.join
      end.join("\n") << "\n"
    end
  end
end
