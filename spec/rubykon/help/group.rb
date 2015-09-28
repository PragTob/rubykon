def group_from(x, y)
  group_tracker.group_of(board.identifier_for(x, y))
end

def board_at(x, y)
  from_board_at(board, x, y)
end

def from_board_at(board, x, y)
  board[board.identifier_for(x, y)]
end