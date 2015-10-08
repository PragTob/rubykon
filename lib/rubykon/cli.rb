module Rubykon
  class CLI

    EXIT = /exit/i

    def initialize(output = $stdout, input = $stdin)
      @output     = output
      @input      = input
      @state      = :init
    end

    def start
      @output.puts 'Please enter a board size (common sizes are 9, 13, and 19)'
      input = get_input
      until input.match /^\d\d*$/
        @output.puts "Input has to be a number. Please try again!"
        input = get_input
      end
      init_game(input)
      game_loop
    end

    private
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

    def init_game(input)
      board_size = input.to_i
      @output.puts "Great starting a #{board_size}x#{board_size} game"
      @game       = Game.new board_size
      @game_state = GameState.new @game
      @mcts       = MCTS::MCTS.new
      @board      = @game.board
    end

    def game_loop
      @output.puts @board
      while true
        if @game.next_turn_color == Board::BLACK
          bot_move
        else
          human_move
        end
      end
    end

    def bot_move
      @output.puts 'Rubykon is thinking...'
      root = @mcts.start @game_state
      move = root.best_move
      best_children = root.children.sort_by(&:win_percentage).reverse.take(10)
      @output.puts best_children.map {|child| "#{@board.x_y_from(child.move.first)} => #{child.win_percentage}"}.join "\n"
      make_move(move)
    end

    def human_move
      @output.puts "Make a move in the form x-y, e.g. 1-1, 4-5 starting from
the top left!"
      coords = get_input
      x, y = coords.split('-').map &:to_i
      identifier = @board.identifier_for(x, y)
      move = [identifier, :white]
      make_move(move)
    end

    def make_move(move)
      @game_state.set_move move
      @output.puts @board
      @output.puts "#{move.last} played at #{@board.x_y_from(move.first)}"
      @output.puts "#{@game.next_turn_color}'s turn to move!'"
    end

  end
end