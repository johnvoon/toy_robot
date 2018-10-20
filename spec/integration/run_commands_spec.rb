# frozen_string_literal: true

require 'toy_robot/run_commands'

RSpec.describe ToyRobot::RunCommands do
  describe 'call' do
    context 'when Toy Robot is placed and last position reported'
    {
      "PLACE 0,0,NORTH\nMOVE\nREPORT" => '0,1,NORTH',
      "PLACE 0,0,NORTH\nLEFT\nREPORT" => '0,0,WEST',
      "PLACE 1,2,EAST\nMOVE\nMOVE\nLEFT\nMOVE\nREPORT" => '3,3,NORTH'
    }.each do |commands, output|
      it "returns #{output} given #{commands}" do
        expect(ToyRobot::RunCommands.call(commands)).to eq(output)
      end
    end

    context 'when Toy Robot is placed and position reported more than once'
    {
      "PLACE 0,0,NORTH\nREPORT\nMOVE\nREPORT" => "0,0,NORTH\n0,1,NORTH",
      "PLACE 1,2,EAST\nMOVE\nREPORT\nMOVE\nLEFT\nMOVE\nREPORT" => "2,2,EAST\n3,3,NORTH"
    }.each do |commands, output|
      it "returns #{output} given #{commands}" do
        expect(ToyRobot::RunCommands.call(commands)).to eq(output)
      end
    end

    context 'when Toy Robot is not placed and last position reported' do
      it 'returns nil' do
        commands = "MOVE\nMOVE\nLEFT\nMOVE\nREPORT"
        expect(ToyRobot::RunCommands.call(commands)).to eq(nil)
      end
    end
  end
end
