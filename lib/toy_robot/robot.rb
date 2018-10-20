# frozen_string_literal: true

module ToyRobot
  # Simple Value object used to store the Toy Robot's state at a given time
  class Robot
    attr_reader :position, :direction

    def initialize(position, direction)
      @position = position
      @direction = direction
    end
  end
end
