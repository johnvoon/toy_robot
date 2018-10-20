# frozen_string_literal: true

require 'ostruct'
require 'toy_robot/robot'

module ToyRobot
  # Commands that can be run on the ToyRobot
  module Commands
    MOVEMENTS = {
      'NORTH' => [0, 1],
      'SOUTH' => [0, -1],
      'EAST' => [1, 0],
      'WEST' => [-1, 0]
    }.freeze

    DIRECTION_CHANGES = {
      'NORTH' => %w[WEST EAST],
      'SOUTH' => %w[EAST WEST],
      'EAST' => %w[NORTH SOUTH],
      'WEST' => %w[SOUTH NORTH]
    }.freeze

    class << self
      def place(command)
        x_position, y_position, direction = command
                                            .split(' ')[1]
                                            .split(',')

        if [x_position.to_i, y_position.to_i].all? { |position| (0..4).cover?(position) }
          OpenStruct.new(
            success?: true,
            data: ToyRobot::Robot.new([x_position.to_i, y_position.to_i], direction)
          )
        else
          OpenStruct.new(success?: false)
        end
      end

      def report(state)
        copy_of_state = deep_copy state
        robot = copy_of_state[:robot]
        copy_of_state[:reported_state] = copy_of_state[:reported_state].concat(
          ["#{robot.position[0]},#{robot.position[1]},#{robot.direction}"]
        )

        copy_of_state
      end

      def move(state)
        copy_of_state = deep_copy state
        robot = copy_of_state[:robot]
        direction = robot.direction
        new_position = robot.position
                            .zip(MOVEMENTS[direction])
                            .map do |operands|
          sum = operands.sum
          (0..4).cover?(sum) ? sum : operands[0]
        end
        copy_of_state[:robot] = ToyRobot::Robot.new(new_position, direction)

        copy_of_state
      end

      def rotate_left(state)
        copy_of_state = deep_copy state
        robot = copy_of_state[:robot]
        position = robot.position
        current_direction = robot.direction
        new_direction = DIRECTION_CHANGES[current_direction][0]
        copy_of_state[:robot] = ToyRobot::Robot.new(position, new_direction)

        copy_of_state
      end

      def rotate_right(state)
        copy_of_state = deep_copy state
        robot = copy_of_state[:robot]
        position = robot.position
        current_direction = robot.direction
        new_direction = DIRECTION_CHANGES[current_direction][1]
        copy_of_state[:robot] = ToyRobot::Robot.new(position, new_direction)

        copy_of_state
      end

      private

      def deep_copy(state)
        Marshal.load(Marshal.dump(state))
      end
    end
  end
end
