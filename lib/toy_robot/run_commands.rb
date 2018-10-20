# frozen_string_literal: true

require 'ostruct'
require 'toy_robot/commands'
require 'toy_robot/toy_robot_error'

module ToyRobot
  # Takes the commands, converts them to an array
  # and runs them through a reducer
  # The reducer maps each command to a function
  # Each function invocation returns updated state
  class RunCommands
    COMMAND_MAP = {
      'MOVE' => ToyRobot::Commands.method(:move),
      'LEFT' => ToyRobot::Commands.method(:rotate_left),
      'RIGHT' => ToyRobot::Commands.method(:rotate_right),
      'REPORT' => ToyRobot::Commands.method(:report)
    }.freeze

    class << self
      def call(commands)
        return OpenStruct.new(success?: false, message: 'No commands were issued.') if commands.empty?
        
        head, *tail = commands.split("\n")
        if head.include? 'PLACE'
          place_result = ToyRobot::Commands.place(head)
          message = 'Toy Robot must be placed within bounds (5 x 5).'
          return OpenStruct.new(success?: false, message: message) unless place_result.success?
          
          initial_state = {
            reported_state: [],
            robot: place_result.data
          }
        else
          message = 'Toy Robot has not yet been placed. Please ensure the PLACE command has been issued first.'
          return OpenStruct.new(success?: false, message: message)
        end

        final_state = tail.reduce(initial_state) do |current_state, command|
          callable = COMMAND_MAP[command]
          next current_state if callable.nil?
          if command.include? 'PLACE'
            place_result = ToyRobot::Commands.place(head)
            next current_state unless place_result.success?

            copy_of_current_state = deep_copy current_state
            copy_of_current_state[:robot] = place_result.data
            copy_of_current_state
          else
            callable.call(current_state)
          end
        end

        if final_state[:reported_state].empty?
          OpenStruct.new(success?: false, data: nil, message: 'No final state was reported')
        else
          OpenStruct.new(success?: true, data: final_state[:reported_state].join("\n"))
        end
      end

      private

      def deep_copy(state)
        Marshal.load(Marshal.dump(state))
      end
    end
  end
end
