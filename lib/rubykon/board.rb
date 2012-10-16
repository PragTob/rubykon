module Rubykon
  class Board
    attr_reader :size
    def initialize(size = 19)
      @board = []
      @size = size
    end
    
    def empty?
      @board.empty?
    end
  end
end
