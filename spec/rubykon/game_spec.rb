require_relative 'spec_helper'

RSpec.describe Rubykon::Game do

  let(:game) {described_class.new}

  context 'creation' do
    subject {game}
    it {is_expected.not_to be_nil}

    it 'has a default size of 19' do
      expect(game.board.size).to eq(19)
    end

    it 'has a move_count of 0' do
      expect(game.move_count).to eq 0
    end

    it 'has no moves playd' do
      expect(game).to be_no_moves_played
    end

    it 'can be created with another size' do
      size = 13
      expect(Rubykon::Game.new(size).board.size).to eq size
    end

    it 'can retrieve the board' do
      expect(game.board).not_to be_nil
    end
  end
end