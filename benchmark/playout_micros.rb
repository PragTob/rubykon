require_relative '../lib/rubykon'
require 'benchmark/ips'

class Rubykon::RandomPlayout
  public :generate_random_move
  public :random_move
  public :plausible_move?
end

class Rubykon::EyeDetector
  public :candidate_eye_color
  public :is_real_eye?
end

class Rubykon::MoveValidator
  public :no_suicide_move?
  public :no_ko_move?
end

Benchmark.ips do |benchmark|
  #benchmark.config time: 30, warmup: 60

  game = Rubykon::Game.new 19
  board = game.board
  playout = Rubykon::RandomPlayout.new

  benchmark.report 'finished?' do
    game.finished?
  end

  benchmark.report 'generate_r_m' do
    playout.generate_random_move(game)
  end

  color = game.next_turn_color
  size  = board.size

  benchmark.report 'random_move' do
    playout.random_move(color, size)
  end

  move = playout.random_move(color, size)

  benchmark.report 'plausible_move?' do
    playout.plausible_move?(move, game)
  end

  validator    = Rubykon::MoveValidator.new

  benchmark.report 'valid?' do
    validator.valid?(move, game)
  end

  benchmark.report 'no_suicide_move?' do
    validator.no_suicide_move?(move, board)
  end

  benchmark.report 'no_ko_move?' do
    validator.no_ko_move?(move, game)
  end

  eye_detector = Rubykon::EyeDetector.new

  x = move.x
  y = move.y

  benchmark.report 'is_eye?' do
    eye_detector.is_eye?(x, y, board)
  end

  benchmark.report 'candidate_eye_color' do
    eye_detector.candidate_eye_color(x, y, board)
  end

  candidate_eye_color = eye_detector.candidate_eye_color(x, y, board)

  benchmark.report 'is_real_eye?' do
    eye_detector.is_real_eye?(x, y, board, candidate_eye_color)
  end

  benchmark.report 'diagonal_colors_of' do
    board.diagonal_colors_of(x, y)
  end

  benchmark.report 'set_valid_move' do
    game.dup.set_valid_move move
  end

  benchmark.report 'set' do
    board.set move
  end

  stone = move

  benchmark.report 'assign' do
    Rubykon::Group.assign(stone, board.dup)
  end

  benchmark.report 'color_to_neighbour' do
    Rubykon::Group.color_to_neighbour(board, stone)
  end

  neighbours_by_color = Rubykon::Group.color_to_neighbour(board, stone)

  # Rubykon::Group.join_group_of_friendly_stones(neighbours_by_color[stone.color], stone)
  
  benchmark.report 'create_own_group' do
    Rubykon::Group.create_own_group(stone)
  end

  # Rubykon::Group.add_liberties(neighbours_by_color[Rubykon::Board::EMPTY_COLOR], stone)
  
  # Rubykon::Group.take_liberties_of_enemies(neighbours_by_color[stone.enemy_color], stone, board)

end
