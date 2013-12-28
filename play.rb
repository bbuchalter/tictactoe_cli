require 'pathname'
base_dir = Pathname.new(File.expand_path(__FILE__)).dirname
lib_dir = base_dir + 'lib'
$LOAD_PATH.unshift(lib_dir.to_s)

require 'setup_cli'

SetupCLI.setup_game if __FILE__ == $PROGRAM_NAME
