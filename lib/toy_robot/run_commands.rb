# frozen_string_literal: true

require 'ostruct'
require 'toy_robot/commands'
require 'toy_robot/toy_robot_error'

module ToyRobot
  class RunCommands
    COMMAND_MAP = {
      'MOVE' => ToyRobot::Commands.method(:move),
      'LEFT' => ToyRobot::Commands.method(:rotate_left),
      'RIGHT' => ToyRobot::Commands.method(:rotate_right),
      'REPORT' => ToyRobot::Commands.method(:report)
    }.freeze

    def self.call(commands)
      head, *tail = commands.split("\n")
      if head.include? 'PLACE'
        initial_state = {
          reported_state: [],
          robot: ToyRobot::Commands.place(head)
        }
      else
        message = 'Toy Robot has not yet been placed. Please ensure the PLACE command has been issued first.'
        return OpenStruct.new(success?: false, message: message)
      end

      final_state = tail.reduce(initial_state) do |current_state, command|
        COMMAND_MAP[command].call(current_state)
      end

      if final_state[:reported_state].empty?
        OpenStruct.new(success?: false, data: nil, message: "No final state was reported")
      else
        OpenStruct.new(success?: true, data: final_state[:reported_state].join("\n"))
      end
    end

    private

    def self.deep_copy(state)
      Marshal.load(Marshal.dump(state))
    end
  end
end
