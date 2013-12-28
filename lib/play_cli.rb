require 'cli_helpers'

class PlayCLI
  include CLIHelpers

  def initialize(game)
    @game = game
  end

  def play_game
    until @game.game_over?
      show_current_game_state
      make_move
    end
    show_outcome
    offer_to_play_again
  end

  private

  def show_current_game_state
    clear_screen
    puts "Turn #{@game.turn_count + 1}."
    puts colored_message("#{current_player.symbol}'s turn.",
                         current_player.color)
    draw_board
  end

  def current_player
    @game.current_player
  end

  def draw_board
    board_state.each do |position, state|
      draw_moves(position, state)
      draw_boarders(position)
    end
    nil
  end

  def board_state
    @game.board_state
  end

  def draw_moves(position, state)
    if state == {}
      print position
    else
      print colored_message(state[:symbol], state[:color])
    end
  end

  def draw_boarders(position)
    if [3, 6, 9].include?(position.to_i)
      puts ''
    else
      print '|'
    end
  end

  def make_move
    position = determine_position_to_move
    @game.make_move(position, current_player)
    rescue ::TicTacToe::Board::PositionTaken
      puts "Position #{position} has already been taken. Please try again."
      make_move
    rescue ::TicTacToe::Board::InvalidPosition
      puts "That's not a valid position. Please try again."
      make_move
  end

  def determine_position_to_move
    if current_player.human?
      position = prompt_user_for_position
    else
      position = current_player.select_position(@game)
    end
    position
  end

  def prompt_user_for_position
    print 'What position would you like to take? '
    gets.chomp
  end

  def show_outcome
    clear_screen
    puts 'Game Over.'
    if draw?
      puts 'The game is a draw.'
    else
      puts colored_message("#{last_move_by.symbol} has won.",
                           last_move_by.color)
    end
    draw_board
  end

  def draw?
    @game.draw?
  end

  def last_move_by
    @game.previous_move_player
  end

  def offer_to_play_again
    print 'Would you like to play again? [Y\\n] '
    again = gets.chomp
    if again != 'n'
      reset_game
      play_game
    end
  end

  def reset_game
    @game.reset
  end
end
