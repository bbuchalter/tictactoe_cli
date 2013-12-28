require_relative "../test_helper"
require "mocha/setup"
require "fake_io"
require "play_cli"
require "tictactoe/game"

class PlayCLITest < Minitest::Test
  def test_draw_game
    cli = prepare_game({computer: {symbol: "X", color: :blue}},
                       {computer: {symbol: "O", color: :green}})
    human_input = ["n"]
    expected_output = %Q{
#{scenario_one}
#{play_again_prompt}}
    
    assert_equal expected_output, FakeIO.each_input(human_input) { cli.play_game }
  end

  def test_game_with_winner_and_human_input
    cli = prepare_game({computer: {symbol: "X", color: :blue}},
                       {human: {symbol: "O", color: :green}})
    human_input = ["9", "5", "n"]
    expected_output = %Q{
#{scenario_two}
#{play_again_prompt}}
    
    assert_equal expected_output, FakeIO.each_input(human_input) { cli.play_game }
  end

  def test_play_again
    cli = prepare_game({computer: {symbol: "X", color: :blue}},
                       {human: {symbol: "O", color: :green}})
    human_input = ["9", "5", "y", "9", "5", "n"]
    expected_output = %Q{
#{scenario_two}
#{play_again_prompt}
#{scenario_two}
#{play_again_prompt}}
    
    assert_equal expected_output, FakeIO.each_input(human_input) { cli.play_game }
  end

  def test_error_handling
    cli = prepare_game({computer: {symbol: "X", color: :blue}},
                       {human: {symbol: "O", color: :green}})
    human_input = ["asdf", "0", "9", "9", "9", "5", "n"]
    expected_output = %Q{
#{scenario_three}
#{play_again_prompt}}
    
    assert_equal expected_output, FakeIO.each_input(human_input) { cli.play_game }
  end
  
  private

  def prepare_game(player_one_options, player_two_options)
    player_one = prepare_player(player_one_options)
    player_two = prepare_player(player_two_options)
    game = TicTacToe::Game.new(player_one, player_two)
    PlayCLI.new(game)
  end

  def prepare_player(options)
    player_type = options.keys.first
    player_options = options.values.first
    symbol = player_options[:symbol]
    color = player_options[:color]

    player_class(player_type).new(symbol, color)
  end

  def player_class(player_type)
    case (player_type)
      when :computer
        TicTacToe::Player::Computer
      when :human
        TicTacToe::Player::Human
      else
        raise "Bad player type: #{player_type}"
    end
  end
  
  def scenario_one
%q{Turn 1.
X's turn.
1|2|3
4|5|6
7|8|9

Turn 2.
O's turn.
X|2|3
4|5|6
7|8|9

Turn 3.
X's turn.
X|2|3
4|O|6
7|8|9

Turn 4.
O's turn.
X|2|X
4|O|6
7|8|9

Turn 5.
X's turn.
X|O|X
4|O|6
7|8|9

Turn 6.
O's turn.
X|O|X
4|O|6
7|X|9

Turn 7.
X's turn.
X|O|X
O|O|6
7|X|9

Turn 8.
O's turn.
X|O|X
O|O|X
7|X|9

Turn 9.
X's turn.
X|O|X
O|O|X
7|X|O

Game Over.
The game is a draw.
X|O|X
O|O|X
X|X|O}
  end
  
  def play_again_prompt
    "Would you like to play again? [Y\\n] "
  end

  def scenario_two
    %q{Turn 1.
X's turn.
1|2|3
4|5|6
7|8|9

Turn 2.
O's turn.
X|2|3
4|5|6
7|8|9
What position would you like to take? 
Turn 3.
X's turn.
X|2|3
4|5|6
7|8|O

Turn 4.
O's turn.
X|2|X
4|5|6
7|8|O
What position would you like to take? 
Turn 5.
X's turn.
X|2|X
4|O|6
7|8|O

Game Over.
X has won.
X|X|X
4|O|6
7|8|O}
  end
  
  def scenario_three
    %q{Turn 1.
X's turn.
1|2|3
4|5|6
7|8|9

Turn 2.
O's turn.
X|2|3
4|5|6
7|8|9
What position would you like to take? That's not a valid position. Please try again.
What position would you like to take? That's not a valid position. Please try again.
What position would you like to take? 
Turn 3.
X's turn.
X|2|3
4|5|6
7|8|O

Turn 4.
O's turn.
X|2|X
4|5|6
7|8|O
What position would you like to take? Position 9 has already been taken. Please try again.
What position would you like to take? Position 9 has already been taken. Please try again.
What position would you like to take? 
Turn 5.
X's turn.
X|2|X
4|O|6
7|8|O

Game Over.
X has won.
X|X|X
4|O|6
7|8|O}
  end
end
