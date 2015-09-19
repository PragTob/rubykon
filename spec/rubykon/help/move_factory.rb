# A simple factory generating valid moves for board sizes starting 9
module Rubykon
  module MoveFactory
    extend self

    DEFAULT_X     = 5
    DEFAULT_Y     = 9
    DEFAULT_COLOR = :black

    def build(options = {})
      x     = options[:x]     || DEFAULT_X
      y     = options[:y]     || DEFAULT_Y
      color = options[:color] || DEFAULT_COLOR
      Rubykon::Move.new x, y, color
    end
  end
end
