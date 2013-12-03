require_relative "../test_helper"
require "fake_io"
require "mocha/setup"
require "setup_cli"

class SetupCLITest < Minitest::Test
  def test_pick_computer_players
    assert_equal %q{
Welcome to TicTacToe.
Should Player 1 (X's) be a computer? [N\y] Ok, X's will be played by the computer.
Should Player 2 (O's) be a computer? [N\y] Ok, O's will be played by the computer.
All set! Press ENTER to begin the game.
}, FakeIO.each_input(['y', 'y']) {
      cli = stub
      PlayCLI.expects(:new).once.returns(cli)
      cli.expects(:play_game).once
      SetupCLI.pick_players
    }
  end

  def test_pick_human_players
    assert_equal %q{
Welcome to TicTacToe.
Should Player 1 (X's) be a computer? [N\y] Ok, X's will be played by a person.
Should Player 2 (O's) be a computer? [N\y] Ok, O's will be played by a person.
All set! Press ENTER to begin the game.
}, FakeIO.each_input(['n', 'n']) {
      cli = stub
      PlayCLI.expects(:new).once.returns(cli)
      cli.expects(:play_game).once
      SetupCLI.pick_players
    }
  end

  def test_setup_human_player
    FakeIO.each_input(['n']) {
      player = SetupCLI.setup_player("Brian", "X", :blue)
      assert_equal "X", player.name
      assert_equal :blue, player.color
      assert_equal [UserInputStrategy], player.strategies
    }
  end


  def test_setup_computer_player
    FakeIO.each_input(['y']) {
      player = SetupCLI.setup_player("Brian", "X", :blue)
      assert_equal "X", player.name
      assert_equal :blue, player.color
      assert_equal Strategies.for_computer, player.strategies
    }
  end
end