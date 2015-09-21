shared_examples_for "has liberties at position" do |x, y, expected|
  it "the group at #{x}-#{y} has #{expected} liberties" do
    expect(board[x, y].group.liberty_count).to eq expected
  end
end