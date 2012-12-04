module Rubykon
  class Stone
    attr_reader :x, :y, :color

    def initialize x, y, color
      @x      = x
      @y      = y
      @color  = color
    end
  end
end
