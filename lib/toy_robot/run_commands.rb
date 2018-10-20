require "toy_robot/commands"

module ToyRobot
  class RunCommands
    COMMAND_MAP = {
      "MOVE" => ToyRobot::Commands.method(:move),
      "LEFT" => ToyRobot::Commands.method(:rotate_left),
      "RIGHT" => ToyRobot::Commands.method(:rotate_right),
      "REPORT" => ToyRobot::Commands.method(:report),
    }

    def self.call(commands)
      head, *tail = commands.split("\n")
      if head.include? "PLACE"
        initial_state = {
          reported_state: [],
          robot: ToyRobot::Commands.place(head)
        }
      else
        puts "Toy Robot has not yet been placed. Please issue the PLACE command"
        return nil
      end

      final_state = tail.reduce(initial_state) do |current_state, command|
        COMMAND_MAP[command].(current_state)
      end
      
      final_state[:reported_state].join("\n")
    end

    private

    def self.deep_copy(state)
      Marshal.load(Marshal.dump(state))
    end
  end
end