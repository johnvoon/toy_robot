module ToyRobot
  class Robot
    attr_reader :position, :direction
    
    def initialize(position, direction)
      @position = position
      @direction = direction
    end
  end
end