require_relative '../lib/rubykon'
require 'benchmark/ips'

class Rubykon::GameScorer
  public :score_empty_cutting_point
  public :find_candidate_color
  public :only_one_color_adjacent?
end

Benchmark.ips do |benchmark|
  benchmark.config time: 30, warmup: 60

  board = Rubykon::Board.new 19
  cutting_point = board[8, 8]
  scorer = Rubykon::GameScorer.new

  benchmark.report 'score_empty_cp' do
    game_score = {Rubykon::Board::BLACK_COLOR => 0, Rubykon::Board::WHITE_COLOR => Rubykon::Game::DEFAULT_KOMI}
    scorer.score_empty_cutting_point(cutting_point, board, game_score)
  end

  benchmark.report 'neighbour_c_of' do
    board.neighbour_colors_of(cutting_point.x, cutting_point.y)
  end

  neighbour_colors = board.neighbour_colors_of(cutting_point.x, cutting_point.y)

  benchmark.report 'find_cand_c_of' do
    scorer.find_candidate_color(neighbour_colors)
  end

  candidate_color = scorer.find_candidate_color(neighbour_colors)

  benchmark.report 'only_one_c_adj?' do
    scorer.only_one_color_adjacent?(neighbour_colors, candidate_color)
  end
end
