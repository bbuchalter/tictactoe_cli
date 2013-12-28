require_relative '../test_helper'
require 'fake_io'
require 'mocha/setup'
require 'setup_cli'

class SetupCLITest < Minitest::Test
  def test_pick_computer_players
    expected_output = greeting +
      [player_one_setup_computer,
       player_two_setup_computer,
       ready_to_play].join("\n")
    assert_equal expected_output, actual_output(%w(y y))
  end

  def test_pick_human_players
    expected_output = greeting +
      [player_one_setup_human,
       player_two_setup_human,
       ready_to_play].join("\n")

    assert_equal expected_output, actual_output(%w(n n))
  end

  def test_pick_human_and_computer_players
    expected_output = greeting +
      [player_one_setup_human,
       player_two_setup_computer,
       ready_to_play].join("\n")

    assert_equal expected_output, actual_output(%w(n y))
  end

  private

  def greeting
    output_scenarios['greeting']
  end

  def player_one_setup_computer
    output_scenarios['player_one_setup_computer']
  end

  def player_two_setup_computer
    output_scenarios['player_two_setup_computer']
  end

  def player_one_setup_human
    output_scenarios['player_one_setup_human']
  end

  def player_two_setup_human
    output_scenarios['player_two_setup_human']
  end

  def ready_to_play
    output_scenarios['ready_to_play']
  end

  def actual_output(human_input)
    FakeIO.each_input(human_input) do
      cli = stub
      PlayCLI.expects(:new).once.returns(cli)
      cli.expects(:play_game).once
      SetupCLI.setup_game
    end
  end
end
