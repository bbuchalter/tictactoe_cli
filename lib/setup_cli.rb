require 'tictactoe/game'
require 'play_cli'
require 'cli_helpers'

class SetupCLI
  extend CLIHelpers

  def self.setup_game
    greet

    player_one_type  = ask_for_player_type("Player 1 (X's)", :green)
    player_two_type = ask_for_player_type("Player 2 (O's)", :blue)

    confirm_start_game

    game = ::TicTacToe::Game.new
    game.setup_player(player_one_type, 'X', :green)
    game.setup_player(player_two_type, 'O', :blue)
    PlayCLI.new(game).play_game
  end

  private

  def self.greet
    clear_screen
    puts 'Welcome to TicTacToe.'
  end

  def self.ask_for_player_type(name, color)
    if player_is_computer(color, name).downcase == 'y'
      player = :computer
      puts colored_message("#{name} will be played by the computer.", color)
    else
      player = :human
      puts colored_message("#{name} will be played by a person.", color)
    end
    player
  end

  def self.player_is_computer(color, name)
    print colored_message("Should #{name} be a computer? [N\\y] ", color)
    gets.chomp
  end

  def self.confirm_start_game
    puts 'All set! Press ENTER to begin the game.'
    gets
  end
end
