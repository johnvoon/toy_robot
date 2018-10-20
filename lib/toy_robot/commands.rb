require "toy_robot/robot"

module ToyRobot
  module Commands
    def self.place(command)
      x_position, y_position, direction = command
        .split(" ")[1]
        .split(",")
        
      ToyRobot::Robot.new([x_position, y_position], direction)
    end

    def self.report(state)
      robot = state[:robot]
      state[:reported_state] = state[:reported_state].concat(
        ["#{robot.position[0]},#{robot.position[1]},#{robot.direction}"]
      )

      state
    end
  end
end