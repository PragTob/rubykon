def group_from(x, y)
  group_overseer.group_of(board.identifier_for(x, y))
end

def board_at(x, y)
  board[board.identifier_for(x, y)]
end