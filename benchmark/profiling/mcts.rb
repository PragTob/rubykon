require_relative '../../lib/rubykon'

game_state = Rubykon::GameState.new
mcts = MCTS::MCTS.new

mcts.start game_state, 200