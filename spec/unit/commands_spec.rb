require 'toy_robot/commands'
require 'toy_robot/robot'

RSpec.describe ToyRobot::Commands do
  describe "place" do
    {
      "PLACE 0,0,NORTH" => ToyRobot::Robot.new([0,0], "NORTH"),
      "PLACE 1,2,EAST" => ToyRobot::Robot.new([1,2], "EAST")
    }.each do |command, expected_robot|
      it "returns ToyRobot::Robot facing #{expected_robot.direction} given #{command}" do
        new_robot = ToyRobot::Commands.place(command)
        expect(expected_robot.direction).to eq(expected_robot.direction)
      end

      it "returns ToyRobot::Robot set at #{expected_robot.position} given #{command}" do
        new_robot = ToyRobot::Commands.place(command)
        expect(expected_robot.position).to eq(expected_robot.position)
      end
    end
  end

  describe "move" do
    context "when move is valid" do
      [
        [
          { reported_state: [], robot: ToyRobot::Robot.new([0,1], "NORTH") },
          { reported_state: [], robot: ToyRobot::Robot.new([0,2], "NORTH") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "WEST") },
          { reported_state: [], robot: ToyRobot::Robot.new([1,1], "WEST") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "EAST") },
          { reported_state: [], robot: ToyRobot::Robot.new([3,1], "EAST") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "SOUTH") },
          { reported_state: [], robot: ToyRobot::Robot.new([2,0], "SOUTH") }
        ]
      ].each do |initial_state, expected_state|
        it "returns ToyRobot::Robot in position #{expected_state[:robot].position.to_s}" do
          new_state = ToyRobot::Commands.move(initial_state)
          expect(new_state[:robot].position).to eq(expected_state[:robot].position)
        end

        it "returns ToyRobot::Robot facing #{expected_state[:robot].direction}" do
          new_state = ToyRobot::Commands.move(initial_state)
          expect(new_state[:robot].direction).to eq(expected_state[:robot].direction)
        end
      end
    end

    context "when move is invalid" do
      [
        [
          { reported_state: [], robot: ToyRobot::Robot.new([0,5], "NORTH") },
          { reported_state: [], robot: ToyRobot::Robot.new([0,5], "NORTH") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([-5,0], "WEST") },
          { reported_state: [], robot: ToyRobot::Robot.new([-5,0], "WEST") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([5,1], "EAST") },
          { reported_state: [], robot: ToyRobot::Robot.new([5,1], "EAST") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([0,-5], "SOUTH") },
          { reported_state: [], robot: ToyRobot::Robot.new([0,-5], "SOUTH") }
        ]
      ].each do |initial_state, expected_state|
        it "returns ToyRobot::Robot object in position #{expected_state[:robot].position.to_s}" do
          new_state = ToyRobot::Commands.move(initial_state)
          expect(new_state[:robot].position).to eq(expected_state[:robot].position)
        end

        it "returns ToyRobot::Robot object facing #{expected_state[:robot].direction}" do
          new_state = ToyRobot::Commands.move(initial_state)
          expect(new_state[:robot].direction).to eq(expected_state[:robot].direction)
        end
      end
    end
  end

  describe "rotate" do
    context "left" do
      [
        [
          { reported_state: [], robot: ToyRobot::Robot.new([0,1], "NORTH") },
          { reported_state: [], robot: ToyRobot::Robot.new([0,1], "WEST") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "WEST") },
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "SOUTH") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "EAST") },
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "NORTH") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "SOUTH") },
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "EAST") }
        ]
      ].each do |initial_state, expected_state|
        it "returns ToyRobot::Robot in position #{expected_state[:robot].position.to_s}" do
          new_state = ToyRobot::Commands.rotate_left(initial_state)
          expect(new_state[:robot].position).to eq(expected_state[:robot].position)
        end
        
        it "returns ToyRobot::Robot facing #{expected_state[:robot].direction}" do
          new_state = ToyRobot::Commands.rotate_left(initial_state)
          expect(new_state[:robot].direction).to eq(expected_state[:robot].direction)
        end
      end
    end

    context "right" do
      [
        [
          { reported_state: [], robot: ToyRobot::Robot.new([0,1], "NORTH") },
          { reported_state: [], robot: ToyRobot::Robot.new([0,1], "EAST") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "WEST") },
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "NORTH") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "EAST") },
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "SOUTH") }
        ],
        [
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "SOUTH") },
          { reported_state: [], robot: ToyRobot::Robot.new([2,1], "WEST") }
        ]
      ].each do |initial_state, expected_state|
        it "returns ToyRobot::Robot in position #{expected_state[:robot].position.to_s}" do
          new_state = ToyRobot::Commands.rotate_right(initial_state)
          expect(new_state[:robot].position).to eq(expected_state[:robot].position)
        end

        it "returns ToyRobot::Robot facing #{expected_state[:robot].direction}" do
          new_state = ToyRobot::Commands.rotate_right(initial_state)
          expect(new_state[:robot].direction).to eq(expected_state[:robot].direction)
        end
      end
    end
  end

  describe "report" do
    [
      [
        { reported_state: [], robot: ToyRobot::Robot.new([0,1], "NORTH") },
        { reported_state: ['0,1,NORTH'], robot: ToyRobot::Robot.new([0,1], "NORTH") }
      ],
      [
        { reported_state: [], robot: ToyRobot::Robot.new([2,1], "WEST") },
        { reported_state: ['2,1,WEST'], robot: ToyRobot::Robot.new([2,1], "WEST") }
      ]
    ].each do |initial_state, expected_state|
      it "returns reported state as #{expected_state[:reported_state].to_s}" do
        new_state = ToyRobot::Commands.report(initial_state)
        expect(new_state[:robot].position).to eq(expected_state[:robot].position)
      end
    end
  end
end
