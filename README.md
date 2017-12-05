# Tic Tac Toe

[![Build Status](https://travis-ci.org/andrewMacmurray/tic-tac-toe.svg?branch=master)](https://travis-ci.org/andrewMacmurray/tic-tac-toe) [![Coverage Status](https://coveralls.io/repos/github/andrewMacmurray/tic-tac-toe/badge.svg?branch=master)](https://coveralls.io/github/andrewMacmurray/tic-tac-toe?branch=master)

A command line game of Tic Tac Toe

## Playing the game

To start the game, clone the repo, cd into it and begin an iex shell:

```sh
> iex -S mix
```

Then run `TicTacToe.run()` and follow the game instructions

## Running the tests

To run the tests with coverage report

```sh
> MIX_ENV=test mix coveralls
```

You can also see a line by line html version to be viewed in a web browser using

```sh
> MIX_ENV=test mix coveralls.html
```

This will create `excoveralls.html` in `/cover`
