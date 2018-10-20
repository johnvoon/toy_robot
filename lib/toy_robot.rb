# frozen_string_literal: true

require 'toy_robot/version'
require 'toy_robot/run_commands'

module ToyRobot
  def self.run(argv)
    file = argv.first    
    raise ToyRobotError.new("No filename provided. Please provide a filename") if file.nil?
    
    commands = File.read(file)
    result = ToyRobot::RunCommands.call(commands)
    output = result.success? ? result.data : result.message
    puts output
  end
end
