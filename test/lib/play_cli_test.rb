require_relative '../test_helper'
require 'mocha/setup'
require 'fake_io'
require 'play_cli'
require 'tictactoe/game'

class PlayCLITest < Minitest::Test
  def test_draw_game
    cli = prepare_game({ computer: { symbol: 'X', color: :blue } },
                       { computer: { symbol: 'O', color: :green } })
    human_input = %w(n)
    expected_output = "\n" + scenario_one + play_again_prompt

    assert_equal expected_output, actual_output(human_input, cli)
  end

  def test_game_with_winner_and_human_input
    cli = prepare_game({ computer: { symbol: 'X', color: :blue } },
                       { human: { symbol: 'O', color: :green } })
    human_input = %w(9 5 n)
    expected_output = "\n" + scenario_two + play_again_prompt

    assert_equal expected_output, actual_output(human_input, cli)
  end

  def test_play_again
    cli = prepare_game({ computer: { symbol: 'X', color: :blue } },
                       { human: { symbol: 'O', color: :green } })
    human_input = %w(9 5 y 9 5 n)
    expected_output = "\n" + scenario_two + play_again_prompt +
                      "\n" + scenario_two + play_again_prompt

    assert_equal expected_output, actual_output(human_input, cli)
  end

  def test_error_handling
    cli = prepare_game({ computer: { symbol: 'X', color: :blue } },
                       { human: { symbol: 'O', color: :green } })
    human_input = %w(asdf 0 9 9 9 5 n)
    expected_output = "\n" + scenario_three + play_again_prompt

    assert_equal expected_output, actual_output(human_input, cli)
  end

  private

  def actual_output(human_input, cli)
    FakeIO.each_input(human_input) { cli.play_game }
  end

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
        fail "Bad player type: #{player_type}"
    end
  end

  def scenario_one
    output_scenarios['scenario_one']
  end

  def play_again_prompt
    'Would you like to play again? [Y\\n] '
  end

  def scenario_two
    output_scenarios['scenario_two']
  end

  def scenario_three
    output_scenarios['scenario_three']
  end
end
