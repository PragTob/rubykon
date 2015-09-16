# A simple factory generating valid moves for board sizes starting 9
module Rubykon
  module StoneFactory

    DEFAULT_X     = 5
    DEFAULT_Y     = 9
    DEFAULT_COLOR = :black

    class << self
      def build(options = {})
        x     = options[:x]     || DEFAULT_X
        y     = options[:y]     || DEFAULT_Y
        color = options[:color] || DEFAULT_COLOR
        Rubykon::Stone.new x, y, color
      end
    end
  end
end
