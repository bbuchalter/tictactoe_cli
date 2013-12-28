require "tictactoe/game"
require "play_cli"
require "cli_helpers"

class SetupCLI
  extend CLIHelpers

  def self.setup_game
    greet
    player_one_type, player_one_symbol, player_one_color = setup_player("Player 1 (X's)", "X", :green)
    player_two_type, player_two_symbol, player_two_color = setup_player("Player 2 (O's)", "O", :blue)
    confirm_start_game

    game = ::TicTacToe::Game.new
    game.setup_player(player_one_type, player_one_symbol, player_one_color)
    game.setup_player(player_two_type, player_two_symbol, player_two_color)
    PlayCLI.new(game).play_game
  end

  private

  def self.greet
    clear_screen
    puts "Welcome to TicTacToe."
  end

  def self.setup_player(name, symbol, color)
    if player_is_computer(color, name).downcase == "y"
      player = [:computer, symbol, color]
      puts colored_message("Ok, #{symbol}'s will be played by the computer.", color)
    else
      player = [:human, symbol, color]
      puts colored_message("Ok, #{symbol}'s will be played by a person.", color)
    end
    player
  end

  def self.player_is_computer(color, name)
    print colored_message("Should #{name} be a computer? [N\\y] ", color)
    gets.chomp
  end

  def self.confirm_start_game
    puts "All set! Press ENTER to begin the game."
    gets
  end
end
