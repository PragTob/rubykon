module Rubykon
  class Board
    def initialize
      @board = []
      @moves_played = 0
    end
    
    def empty?
      @board.empty?
    end
  end
end
