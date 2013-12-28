require 'colorize'

module CLIHelpers
  def clear_screen
    if fake_io?
      puts ''
    else
      system('clear')
    end
  end

  def colored_message(message, color)
    if fake_io?
      message
    else
      message.colorize(color)
    end
  end

  private

  def fake_io?
    $stdout.class.name == 'FakeIO'
  end
end
