# Board itself acts a bit like a giant 2 dimensional array - but one based
# not zero based

module Rubykon
  class Board
    include Enumerable
    
    EMPTY_SYMBOL = nil
    
    attr_reader :size, :moves
    
    def initialize(size = 19)
      @size           = size
      @move_validator = MoveValidator.new
      @moves          = []
      initialize_board
    end
    
    def initialize_board
      @board = Array.new @size
      @board = @board.map { |each| Array.new @size }
    end
    
    def each(&block)
      @board.flatten.each &block
    end
    
    def play(stone)
      if @move_validator.validate stone, self
        self[stone.x, stone.y] = stone
        @moves << stone
        true
      else
        false
      end
    end
    
    # the [] and []= methods encapsulate the non zero based ness
    def [](x,y)
      @board[x - 1][y - 1]
    end
    
    def []=(x, y, stone)
      @board[x - 1][y - 1] = stone
    end
    
    def move_count
      @moves.size
    end
    
    def no_stones_played?
      @moves.empty?
    end
    
  end
end
