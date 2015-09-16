require_relative 'spec_helper'

describe 'Playing moves on a board:' do

  let(:board) {Rubykon::Board.new board_size}
  let(:board_size) {19}
  let(:simple_x) {1}
  let(:simple_y) {1}
  let(:simple_color) {:black}

  describe 'A simple move' do
    let(:stone) {Rubykon::Stone.new simple_x, simple_y, simple_color}

    before :each do
      board.play stone
    end
    
    it 'lets the board retrieve the stone at that position' do
      expect(board[simple_x, simple_y]).to eq stone
    end
    
    it 'sets the move_count to 1' do
      expect(board.move_count).to eq 1
    end
    
    it 'should have played moves' do
      expect(board).not_to be_no_stones_played
    end
    
    it 'can retrieve the played move through moves' do
      expect(board.moves.first).to eq stone
    end
    
    it 'returns a truthy value' do
      legal_move = Rubykon::StoneFactory.build x: simple_x + 2 #slightly different to avoid conflicts
      expect(board.play(legal_move)).to eq(true) 
    end
  end
  
  describe 'A couple of moves' do
    let(:stones) do
      [ Rubykon::StoneFactory.build(x: 3, y: 7, color: :black),
        Rubykon::StoneFactory.build(x: 5, y: 7, color: :white),
        Rubykon::StoneFactory.build(x: 3, y: 10, color: :black)
      ]
    end

    before :each do
      stones.each {|move| board.play move}
    end
    
    it 'sets the move_count to the number of moves played' do
      expect(board.move_count).to eq stones.size
    end
    
    it 'remembers the moves in the correct order' do
      expect(board.moves).to eq stones
    end
  
  end
  
  describe 'Illegal moves' do
    it 'is illegal to play moves with a greater x than the board size' do
      illegal_move = Rubykon::Stone.new board_size + 1, simple_y, simple_color
      expect(board.play(illegal_move)).to eq(false)
    end
    
    it 'is illegal to play moves with a greater y than the board size' do
      illegal_move = Rubykon::Stone.new simple_x, board_size + 1, simple_color
      expect(board.play(illegal_move)).to eq(false)
    end
  end

end
