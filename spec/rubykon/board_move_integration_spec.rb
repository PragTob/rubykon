require_relative 'spec_helper'

module Rubykon
  describe 'Playing moves on a board:' do
    let(:game) {Game.new board_size}
    let(:board) {game.board}
    let(:board_size) {19}
    let(:simple_x) {1}
    let(:simple_y) {1}
    let(:simple_color) {:black}

    describe 'A simple move' do
      let(:move) {Stone.new simple_x, simple_y, simple_color}

      before :each do
        game.play move
      end

      it 'lets the board retrieve the move at that position' do
        expect(board[simple_x, simple_y]).to eq move
      end

      it 'sets the move_count to 1' do
        expect(game.move_count).to eq 1
      end

      it 'should have played moves' do
        expect(game).not_to be_no_moves_played
      end

      it 'can retrieve the played move through moves' do
        expect(game.moves.first).to eq move
      end

      it 'returns a truthy value' do
        legal_move = Rubykon::StoneFactory.build x: simple_x + 2 #slightly different to avoid conflicts
        expect(game.play(legal_move)).to eq(true)
      end
    end

    describe 'A couple of moves' do
      let(:moves) do
        [ StoneFactory.build(x: 3, y: 7, color: :black),
          StoneFactory.build(x: 5, y: 7, color: :white),
          StoneFactory.build(x: 3, y: 10, color: :black)
        ]
      end

      before :each do
        moves.each {|move| game.play move}
      end

      it 'sets the move_count to the number of moves played' do
        expect(game.move_count).to eq moves.size
      end

      it 'remembers the moves in the correct order' do
        expect(game.moves).to eq moves
      end

    end

    describe 'Illegal moves' do
      it 'is illegal to play moves with a greater x than the board size' do
        illegal_move = StoneFactory.build x: board_size + 1
        expect(game.play(illegal_move)).to eq(false)
      end

      it 'is illegal to play moves with a greater y than the board size' do
        illegal_move = StoneFactory.build y: board_size + 1
        expect(game.play(illegal_move)).to eq(false)
      end
    end
  end
end