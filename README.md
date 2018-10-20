# ToyRobot

My implementation of the Toy Robot code challenge. Uses functional style Ruby and is partially inspired by Redux in the use of a reducer.

## Installation

Clone the repo:

    git clone git@github.com:johnvoon/toy_robot.git

And then execute:

    $ bundle exec rake install

## Usage

Create a file with Toy Robot commands, e.g.:

    PLACE 0,0,NORTH
    LEFT
    RIGHT
    MOVE
    REPORT

And then run the program, passing in the filename as an argument. E.g. if the file is `commands.txt`. An error is returned if a filename is not given:

    bin/toy_robot commands.txt

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
