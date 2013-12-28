require_relative "../test_helper"
require "mocha/setup"
require "cli_helpers"

class CLIHelpersTest < Minitest::Test
  class Dummy
    include CLIHelpers
  end

  def test_clear_screen
    dummy = Dummy.new
    dummy.expects(:system).with("clear")
    dummy.clear_screen
  end

  def test_colored_message
    message = stub
    color = stub
    message.expects(:colorize).with(color)
    Dummy.new.colored_message(message, color)
  end
end
