# Board itself acts a bit like a giant 2 dimensional array - but one based
# not zero based

module Rubykon
  class Board
    include Enumerable
    
    EMPTY_SYMBOL = nil
    
    attr_reader :size
    
    def initialize(size = 19)
      @size           = size
      @move_validator = MoveValidator.new
      initialize_board
    end
    
    def initialize_board
      @board = Array.new @size
      @board = @board.map { |each| Array.new @size }
    end
    
    def each(&block)
      @board.flatten.each &block
    end
    
    def play(move)
      if @move_validator.validate move, self
        self[move.x, move.y] = move.color
      else
        raise IllegalMoveException
      end
    end
    
    # the [] and []= methods encapsulate the non zero based ness
    def [](x,y)
      @board[x - 1][y - 1]
    end
    
    def []=(x, y, value)
      @board[x - 1][y - 1] = value
    end
    
  end
end
