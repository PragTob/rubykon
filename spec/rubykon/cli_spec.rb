require_relative 'spec_helper'
require 'stringio'

module Rubykon
  RSpec.describe CLI do
    subject {described_class.new(output, input)}
    let(:output) {StringIO.new}
    let(:output_read) {output.flush; output.rewind; output.read}
    let(:outputs) {output_read.split "\n"}
    let(:input) {StringIO.new}

    describe 'choosing a board' do

      # input has to go in before starting, otherwise we are stuck waiting
      it "displays a message prompting the user to choose a game type" do
        input.puts 'exit'
        input.rewind
        expect {subject.start}.to raise_error SystemExit
        expect(output_read).to match /board size/
        expect(output_read).to match /9.*13.*19/
      end

      it "waits for some input of a board size" do
        input.puts '9'
        input.puts 'exit'
        input.rewind
        expect {subject.start}.to raise_error SystemExit
        expect(output_read).to match /starting.*9x9/
      end

      it "keeps prompting until a number was entered" do
        input.puts 'h9'
        input.puts '19'
        input.puts 'exit'
        input.rewind
        expect {subject.start}.to raise_error SystemExit
        expect(output_read).to match /number.*try again/i
        expect(output_read).to match /starting/i
      end

      it "makes a whole test through all the things" do
        input.puts '9'
        input.puts '1-1'
        input.puts 'exit'
        input.rewind
        expect {subject.start}.to raise_error SystemExit
        expect(output_read).to match Board.new(9).to_s
        expect(output_read).to match /O......../
        expect(output_read).to match /starting/i
      end
    end
  end
end