# a simple script doing a full playout to use it with profiling tools

require_relative '../../lib/rubykon/'

game = Rubykon::Game.new
playouter = Rubykon::RandomPlayout.new
p playouter.play(game)