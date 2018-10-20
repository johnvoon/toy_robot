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
        result = ToyRobot::RunCommands.call(commands)
        expect(result.data).to eq(output)
      end
    end

    context 'when Toy Robot is placed and position reported more than once'
    {
      "PLACE 0,0,NORTH\nREPORT\nMOVE\nREPORT" => "0,0,NORTH\n0,1,NORTH",
      "PLACE 1,2,EAST\nMOVE\nREPORT\nMOVE\nLEFT\nMOVE\nREPORT" => "2,2,EAST\n3,3,NORTH"
    }.each do |commands, output|
      it "returns #{output} given #{commands}" do
        result = ToyRobot::RunCommands.call(commands)
        expect(result.data).to eq(output)
      end
    end

    context 'when Toy Robot is not placed and last position reported' do
      it 'returns nil' do
        commands = "MOVE\nMOVE\nLEFT\nMOVE\nREPORT"
        result = ToyRobot::RunCommands.call(commands)

        expect(result.success?).to eq(false)
      end
    end

    context 'Toy Robot is placed and last position not reported' do
      it 'returns result object with data property as nil' do
        commands = "PLACE 0,0,NORTH\nMOVE\nMOVE\nLEFT\nMOVE"
        result = ToyRobot::RunCommands.call(commands)

        expect(result.success?).to eq(false)
        expect(result.data).to eq(nil)
      end
    end

    context 'Toy Robot is placed out of bounds' do
      it 'returns result object with success? property as false' do
        commands = "PLACE 0,5,NORTH\nMOVE\nMOVE\nLEFT\nMOVE"
        result = ToyRobot::RunCommands.call(commands)

        expect(result.success?).to eq(false)
      end
    end

    context 'No commands issued' do
      it 'returns result object with success? property equal to false' do
        commands = ''
        result = ToyRobot::RunCommands.call(commands)

        expect(result.success?).to eq(false)
      end
    end

    context 'Commands intermingled with rubbish input' do
      {
        "PLACE 0,0,NORTH\n&*$%^&%&_input\nREPORT\nMOVE\nREPORT" => "0,0,NORTH\n0,1,NORTH"
      }.each do |commands, output|
        it "returns #{output} given #{commands}" do
          result = ToyRobot::RunCommands.call(commands)
          expect(result.data).to eq(output)
        end
      end
    end

    context 'Commands intermingled with out of bound placement' do
      {
        "PLACE 0,0,NORTH\nPLACE 0,5,NORTH\nREPORT\nMOVE\nREPORT" => "0,0,NORTH\n0,1,NORTH"
      }.each do |commands, output|
        it "returns #{output} given #{commands}" do
          result = ToyRobot::RunCommands.call(commands)
          expect(result.data).to eq(output)
        end
      end
    end
  end
end
