# frozen_string_literal: true

require 'toy_robot/robot'

module ToyRobot
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

    def self.place(command)
      x_position, y_position, direction = command
                                          .split(' ')[1]
                                          .split(',')

      ToyRobot::Robot.new([x_position.to_i, y_position.to_i], direction)
    end

    def self.report(state)
      copy_of_state = deep_copy state
      robot = copy_of_state[:robot]
      copy_of_state[:reported_state] = copy_of_state[:reported_state].concat(
        ["#{robot.position[0]},#{robot.position[1]},#{robot.direction}"]
      )

      copy_of_state
    end

    def self.move(state)
      copy_of_state = deep_copy state
      robot = copy_of_state[:robot]
      direction = copy_of_state[:robot].direction
      new_position = copy_of_state[:robot].position
                                          .zip(MOVEMENTS[direction])
                                          .map do |operands|
        sum = operands.sum
        sum.abs <= 5 ? sum : operands[0]
      end
      copy_of_state[:robot] = ToyRobot::Robot.new(new_position, direction)

      copy_of_state
    end

    def self.rotate_left(state)
      copy_of_state = deep_copy state
      robot = copy_of_state[:robot]
      position = robot.position
      current_direction = robot.direction
      new_direction = DIRECTION_CHANGES[current_direction][0]
      copy_of_state[:robot] = ToyRobot::Robot.new(position, new_direction)

      copy_of_state
    end

    def self.rotate_right(state)
      copy_of_state = deep_copy state
      robot = copy_of_state[:robot]
      position = robot.position
      current_direction = robot.direction
      new_direction = DIRECTION_CHANGES[current_direction][1]
      copy_of_state[:robot] = ToyRobot::Robot.new(position, new_direction)

      copy_of_state
    end

    private

    def self.deep_copy(state)
      Marshal.load(Marshal.dump(state))
    end
  end
end
