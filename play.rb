require 'pathname'
base_dir = Pathname.new(File.expand_path(__FILE__)).dirname
lib_dir = base_dir + "lib"
$:.unshift(lib_dir.to_s)

require "setup_cli"

if __FILE__ == $0
  SetupCLI.pick_players
end