module Rubykon
  class CLI

    EXIT            = /exit/i
    CHAR_LABELS     = GTPCoordinateConverter::X_CHARS
    X_LABEL_PADDING = ' '.freeze * 4
    Y_LABEL_WIDTH   = 3

    def initialize(output = $stdout, input = $stdin)
      @output         = output
      @input          = input
      @state          = :init
      @move_validator = MoveValidator.new
    end

    def start
      @output.puts 'Please enter a board size (common sizes are 9, 13, and 19)'
      size = get_digit_input
      @output.puts <<-PLAYOUTS
Please enter the number of playouts you'd like rubykon to make!
More playouts means rubykon is stronger, but also takes longer.
For 9x9 10000 is an acceptable value, for 19x19 1000 already take a long time.
      PLAYOUTS
      playouts = get_digit_input
      init_game(size, playouts)
      game_loop
    end

    private
    def get_digit_input
      input = get_input
      until input.match /^\d\d*$/
        @output.puts "Input has to be a number. Please try again!"
        input = get_input
      end
      input
    end

    def get_input
      @output.print '> '
      input = @input.gets.chomp
      exit_if_desired(input)
      input
    end

    def exit_if_desired(input)
      quit if input.match EXIT
    end

    def quit
      @output.puts "too bad, bye bye!"
      exit
    end

    def init_game(size, playouts)
      board_size = size.to_i
      @output.puts "Great starting a #{board_size}x#{board_size} game with #{playouts} playouts"
      @game          = Game.new board_size
      @game_state    = GameState.new @game
      @mcts          = MCTS::MCTS.new
      @board         = @game.board
      @gtp_converter = GTPCoordinateConverter.new(@board)
      @playouts      = playouts.to_i
    end

    def game_loop
      print_board
      while true
        if bot_turn?
          bot_move
        else
          human_move
        end
      end
    end

    def bot_turn?
      @game.next_turn_color == Board::BLACK
    end

    def print_board
      @output.puts labeled_board
    end

    def labeled_board
      rows = []
      x_labels = X_LABEL_PADDING + CHAR_LABELS.take(@board.size).join(' ')
      rows << x_labels
      board_rows = @board.to_s.split("\n").each_with_index.map do |row, i|
        y_label = "#{@board.size - i}".rjust(Y_LABEL_WIDTH)
        y_label + row + y_label
      end
      rows += board_rows
      rows << x_labels
      rows.join "\n"
    end

    def bot_move
      @output.puts 'Rubykon is thinking...'
      root = @mcts.start @game_state, @playouts
      move = root.best_move
      best_children = root.children.sort_by(&:win_percentage).reverse.take(10)
      @output.puts best_children.map {|child| "#{@gtp_converter.to(child.move.first)} => #{child.win_percentage}"}.join "\n"
      make_move(move)
    end

    def human_move
      move = ask_human_for_move
      until @move_validator.valid?(*move, @game_state.game)
        puts 'That was an invalid move, please try again!'
        move = ask_human_for_move
      end
      make_move(move)
    end

    def ask_human_for_move
      @output.puts "Make a move in the form XY, e.g. A19, D7 as the labels indicate!"
      coords     = get_input
      identifier = @gtp_converter.from(coords)
      [identifier, :white]
    end

    def make_move(move)
      @game_state.set_move move
      print_board
      @output.puts "#{move.last} played at #{@gtp_converter.to(move.first)}"
      @output.puts "#{@game.next_turn_color}'s turn to move!'"
    end

  end
end