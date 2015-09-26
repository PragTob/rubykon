require_relative 'spec_helper'

module Rubykon
  RSpec.describe RandomPlayout do
    let(:original_game) {Game.new 19}
    let(:playouter) {described_class.new}

    describe "#play" do
      it "returns some score" do
        result = playouter.play original_game
        expect(result[:black]).to be >= 0
        expect(result[:white]).to be >= 0
      end
    end

    describe "#playout_for" do
      it "sets a lot of moves... " do
        played_out = playouter.playout_for(original_game)
        expect(played_out.move_count).to be >= 150
      end
    end
  end
end