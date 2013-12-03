require "tictactoe"
require "board"
require "player"
require "strategies"
require "play_cli"
require "cli_helpers"

class SetupCLI
  extend CLIHelpers
  
  def self.pick_players
    greet
    player1 = setup_player("Player 1 (X's)", "X", :green)
    player2 = setup_player("Player 2 (O's)", "O", :blue)
    start_game(player1, player2)
  end

  private

  def self.greet
    clear_screen
    puts "Welcome to TicTacToe."
  end

  def self.setup_player(name, symbol, color)
    if player_is_computer(color, name).downcase == "y"
      player = Player.new(symbol, Strategies.for_computer, color)
      puts colored_message("Ok, #{symbol}'s will be played by the computer.", color)
    else
      player = Player.new(symbol, [UserInputStrategy], color)
      puts colored_message("Ok, #{symbol}'s will be played by a person.", color)
    end
    player
  end

  def self.player_is_computer(color, name)
    print colored_message("Should #{name} be a computer? [N\\y] ", color)
    gets.chomp
  end

  def self.start_game(player1, player2)
    puts "All set! Press ENTER to begin the game."
    gets
    game = TicTacToe.new(Board.new)
    PlayCLI.new(game, player1, player2).play_game
  end
end