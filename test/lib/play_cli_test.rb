require_relative "../test_helper"
require "mocha/setup"
require "fake_io"
require "play_cli"
require "tictactoe"
require "board"
require "player"
require "strategies"

class PlayCLITest < Minitest::Test
  def test_simple_strategy
    game = TicTacToe.new(Board.new)
    player1 = Player.new("X", [SimpleStrategy], :blue)
    player2 = Player.new("O", [SimpleStrategy], :blue)
    cli = PlayCLI.new(game, player1, player2)
    expected_output = %q{
Turn 1.
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
X|O|3
4|5|6
7|8|9

Turn 4.
O's turn.
X|O|X
4|5|6
7|8|9

Turn 5.
X's turn.
X|O|X
O|5|6
7|8|9

Turn 6.
O's turn.
X|O|X
O|X|6
7|8|9

Turn 7.
X's turn.
X|O|X
O|X|O
7|8|9

Game Over.
X has won.
X|O|X
O|X|O
X|8|9
Would you like to play again? [Y\n] }
    assert_equal expected_output, FakeIO.each_input(["n"]) { cli.play_game }
  end

  def test_win_now_strategy
    game = TicTacToe.new(Board.new)
    player1 = Player.new("X", [UserInputStrategy], :blue)
    player2 = Player.new("O", [WinNowStrategy, SimpleStrategy], :blue)
    cli = PlayCLI.new(game, player1, player2)
    expected_output = %q{
Turn 1.
X's turn.
1|2|3
4|5|6
7|8|9
What move would you like to make? 
Turn 2.
O's turn.
1|2|3
4|5|6
7|8|X

Turn 3.
X's turn.
O|2|3
4|5|6
7|8|X
What move would you like to make? 
Turn 4.
O's turn.
O|2|3
4|X|6
7|8|X

Turn 5.
X's turn.
O|O|3
4|X|6
7|8|X
What move would you like to make? 
Turn 6.
O's turn.
O|O|X
4|X|6
7|8|X

Turn 7.
X's turn.
O|O|X
O|X|6
7|8|X
What move would you like to make? 
Turn 8.
O's turn.
O|O|X
O|X|6
7|X|X

Game Over.
O has won.
O|O|X
O|X|6
O|X|X
Would you like to play again? [Y\n] }
    assert_equal expected_output, FakeIO.each_input(["9", "5", "3", "8", "n"]) { cli.play_game }
  end

  def test_block_opponent_strategy
    game = TicTacToe.new(Board.new)
    player1 = Player.new("X", [UserInputStrategy], :blue)
    player2 = Player.new("O", [WinNowStrategy, BlockOpponentStrategy, SimpleStrategy], :blue)
    cli = PlayCLI.new(game, player1, player2)
    expected_output = %q{
Turn 1.
X's turn.
1|2|3
4|5|6
7|8|9
What move would you like to make? 
Turn 2.
O's turn.
X|2|3
4|5|6
7|8|9

Turn 3.
X's turn.
X|O|3
4|5|6
7|8|9
What move would you like to make? 
Turn 4.
O's turn.
X|O|3
X|5|6
7|8|9

Turn 5.
X's turn.
X|O|3
X|5|6
O|8|9
What move would you like to make? 
Turn 6.
O's turn.
X|O|3
X|X|6
O|8|9

Turn 7.
X's turn.
X|O|3
X|X|O
O|8|9
What move would you like to make? 
Game Over.
X has won.
X|O|3
X|X|O
O|8|X
Would you like to play again? [Y\n] }
    assert_equal expected_output, FakeIO.each_input(["1", "4", "5", "9", "n"]) { cli.play_game }
  end

def test_play_again
    game = TicTacToe.new(Board.new)
    player1 = Player.new("X", [SimpleStrategy], :blue)
    player2 = Player.new("O", [SimpleStrategy], :blue)
    cli = PlayCLI.new(game, player1, player2)
    expected_output = %q{
Turn 1.
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
X|O|3
4|5|6
7|8|9

Turn 4.
O's turn.
X|O|X
4|5|6
7|8|9

Turn 5.
X's turn.
X|O|X
O|5|6
7|8|9

Turn 6.
O's turn.
X|O|X
O|X|6
7|8|9

Turn 7.
X's turn.
X|O|X
O|X|O
7|8|9

Game Over.
X has won.
X|O|X
O|X|O
X|8|9
Would you like to play again? [Y\n] 
Turn 1.
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
X|O|3
4|5|6
7|8|9

Turn 4.
O's turn.
X|O|X
4|5|6
7|8|9

Turn 5.
X's turn.
X|O|X
O|5|6
7|8|9

Turn 6.
O's turn.
X|O|X
O|X|6
7|8|9

Turn 7.
X's turn.
X|O|X
O|X|O
7|8|9

Game Over.
X has won.
X|O|X
O|X|O
X|8|9
Would you like to play again? [Y\n] }
    assert_equal expected_output, FakeIO.each_input(["y", "n"]) { cli.play_game }
  end

  def test_tie_game
    game = TicTacToe.new(Board.new)
    player1 = Player.new("X", [UserInputStrategy], :blue)
    player2 = Player.new("O", [SimpleStrategy], :blue)
    cli = PlayCLI.new(game, player1, player2)
    expected_output = %q{
Turn 1.
X's turn.
1|2|3
4|5|6
7|8|9
What move would you like to make? 
Turn 2.
O's turn.
1|X|3
4|5|6
7|8|9

Turn 3.
X's turn.
O|X|3
4|5|6
7|8|9
What move would you like to make? 
Turn 4.
O's turn.
O|X|3
4|5|6
X|8|9

Turn 5.
X's turn.
O|X|O
4|5|6
X|8|9
What move would you like to make? 
Turn 6.
O's turn.
O|X|O
X|5|6
X|8|9

Turn 7.
X's turn.
O|X|O
X|O|6
X|8|9
What move would you like to make? 
Turn 8.
O's turn.
O|X|O
X|O|X
X|8|9

Turn 9.
X's turn.
O|X|O
X|O|X
X|O|9
What move would you like to make? 
Game Over.
The game is a draw.
O|X|O
X|O|X
X|O|X
Would you like to play again? [Y\n] }
    assert_equal expected_output, FakeIO.each_input(["2", "7", "4", "6", "9", "n"]) { cli.play_game }
  end

  def test_error_handling
    game = TicTacToe.new(Board.new)
    player1 = Player.new("X", [UserInputStrategy], :blue)
    player2 = Player.new("O", [SimpleStrategy], :blue)
    cli = PlayCLI.new(game, player1, player2)
    expected_output = %q{
Turn 1.
X's turn.
1|2|3
4|5|6
7|8|9
What move would you like to make? That's not a valid move. Please try again.
What move would you like to make? That's not a valid move. Please try again.
What move would you like to make? 
Turn 2.
O's turn.
X|2|3
4|5|6
7|8|9

Turn 3.
X's turn.
X|O|3
4|5|6
7|8|9
What move would you like to make? 
Turn 4.
O's turn.
X|O|X
4|5|6
7|8|9

Turn 5.
X's turn.
X|O|X
O|5|6
7|8|9
What move would you like to make? That position has already been taken. Please try again.
What move would you like to make? 
Turn 6.
O's turn.
X|O|X
O|X|6
7|8|9

Turn 7.
X's turn.
X|O|X
O|X|O
7|8|9
What move would you like to make? 
Game Over.
X has won.
X|O|X
O|X|O
X|8|9
Would you like to play again? [Y\n] }
    assert_equal expected_output, FakeIO.each_input(["asdf","0","1", "3", "3", "5", "7", "n"]) { cli.play_game }
  end
end