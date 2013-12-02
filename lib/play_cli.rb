require "cli_helpers"

class PlayCLI
  include CLIHelpers

  def initialize(game, player1, player2)
    @game = game
    @board = game.board
    @player1 = player1
    @player2 = player2
    @last_move_by = player2
    @turn_count = 0
  end

  def play_game
    while !@game.game_over?
      @turn_count+=1
      show_current_game_state
      make_move
    end
    show_outcome
    offer_to_play_again
  end

  private

  def show_current_game_state
    clear_screen
    puts "Turn #{@turn_count}."
    puts colored_message("#{current_player.name}'s turn.", current_player.color)
    draw_board
  end

  def make_move
    @game.move_for(current_player, get_move_from_current_player)
    @last_move_by = current_player
  end

  def get_move_from_current_player
    begin
      current_player.make_move(@game)
    rescue UserInputStrategy::MoveAlreadyMade
      puts "That position has already been taken. Please try again."
      get_move_from_current_player
    rescue UserInputStrategy::InvalidInput
      puts "That's not a valid move. Please try again."
      get_move_from_current_player
    end
  end

  def show_outcome
    clear_screen
    puts "Game Over."
    if @game.winner?
      puts colored_message("#{@last_move_by.name} has won.", @last_move_by.color)
    else
      puts "The game is a draw."
    end
    draw_board
  end


  def current_player
    @last_move_by == @player2 ? @player1 : @player2
  end

  def draw_board
    @board.each_with_index do |move, position|
      draw_moves(move, position)
      draw_boarders(position)
    end
    nil
  end

  def draw_boarders(position)
    if [2, 5, 8].include?(position)
      puts ""
    else
      print "|"
    end
  end

  def draw_moves(move, position)
    if move.made?
      player = move.player
      print colored_message(player.name, player.color)
    else
      print (position+1).to_s
    end
  end

  def offer_to_play_again
    print "Would you like to play again? [Y\\n] "
    again = gets.chomp
    if again != "n"
      reset_game
      play_game
    end
  end

  def reset_game
    @board.reset
    @last_move_by = @player2
    @turn_count = 0
  end
end