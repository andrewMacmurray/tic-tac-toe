defmodule ConsoleControllerTest do
  use ExUnit.Case
  alias TicTacToe.Model
  alias TicTacToe.Console.Controller

  test "Controller.parse_guess! take a user guess and return a result" do
    expected = 3
    actual   = Controller.parse_guess!("3\n")
    assert actual == expected

    expected = :error
    actual = Controller.parse_guess!("hello?")
    assert actual == expected
  end

  test "Controller.handle_init should print the initial state and return the state unmodified" do
    state = Model.init({:human_v_human, :X, :player_1})
    actual = Controller.handle_init(state, FakeIO)
    assert actual == state

    state = Model.init(:computer_v_computer)
    actual = Controller.handle_init(state, FakeIO)
    assert actual == state

    state = Model.init({:human_v_computer, :X, :player_1})
    actual = Controller.handle_init(state, FakeIO)
    assert actual == state

    state = Model.init({:human_v_computer, :O, :player_2})
    actual = Controller.handle_init(state, FakeIO)
    assert actual == state
  end

  test "Controller.handle_guess should take a game state for human_v_human,
        prompt the user for a guess
        and correctly update state" do
    state = Model.init({:human_v_human, :X, :player_1})
    guess = 5

    expected = Model.update(state, guess)
    actual   = Controller.handle_guess(state, IOGuess5)
    assert actual == expected
  end

  test "Controller.handle_guess should return the original state
        if an unrecognised guess is given" do
    original_state = Model.init({:human_v_human, :X, :player_1})

    actual = Controller.handle_guess(original_state, IOGuessUnrecognized)
    assert actual == original_state
  end

  test "If a move has already been taken should return the original state" do
    original_state = Model.init({:human_v_human, :X, :player_1}) |> Model.update(5)
    actual = Controller.handle_guess(original_state, IOGuess5)

    assert actual == original_state
  end

  test "Controller.handle_guess should return a new state for a :computer_v_computer game" do
    initial_state = Model.init(:computer_v_computer)
    actual = Controller.handle_guess(initial_state, FakeIO)

    expected = Model.update(initial_state, 5)
    assert actual == expected
  end

  test "Controller.handle_guess should return a new state for a :human_v_computer game
        where human guesses first" do
    initial_state = Model.init({:human_v_computer, :X, :player_1})
    actual = Controller.handle_guess(initial_state, IOGuess9)
    expected = Model.update(initial_state, 9)
    assert actual == expected

    initial_state = Model.init({:human_v_computer, :X, :player_1})
    actual = Controller.handle_guess(initial_state, IOGuessUnrecognized)
    assert actual == initial_state

    initial_state =
      Model.init({:human_v_computer, :X, :player_1})
      |> Model.update(5)
      |> Model.update(1)
    actual = Controller.handle_guess(initial_state, IOGuess5)
    assert actual == initial_state
  end

  test "Controller.handle_guess should return a new state for a :human_v_computer game
        where computer guesses first" do
    initial_state = Model.init({:human_v_computer, :O, :player_2})
    actual        = Controller.handle_guess(initial_state, FakeIO)

    expected = Model.update(initial_state, 5)
    assert actual == expected
  end

  test "Controller.handle_terminus shoud pass state through unmodified if not in terminal state" do
    state = Model.init({:human_v_human, :X, :player_1})
    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == state

    state = Model.init(:computer_v_computer)
    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == state

    state = Model.init({:human_v_computer, :O, :player_2})
    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == state
  end

  test "Controller.handle_terminus should handle and return terminal state for human_v_human game" do
    initial = Model.init({:human_v_human, :X, :player_1})
    state = [5,1,2,4,8] |> Enum.reduce(initial, fn(x, acc) -> Model.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :player_1_win

    initial = Model.init({:human_v_human, :X, :player_1})
    state = [5,1,2,8,9,3,6,4,7] |> Enum.reduce(initial, fn(x, acc) -> Model.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :draw
  end

  test "Controller.handle_terminus should handle and return terminal state for computer_v_computer game" do
    initial = Model.init(:computer_v_computer)
    state = [5,1,2,4,8] |> Enum.reduce(initial, fn(x, acc) -> Model.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :player_1_win

    initial = Model.init(:computer_v_computer)
    state = [5,1,2,8,9,3,6,4,7] |> Enum.reduce(initial, fn(x, acc) -> Model.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :draw
  end

  test "Controller.handle_terminus should handle and return terminal state for human_v_computer game" do
    initial = Model.init({:human_v_computer, :X, :player_1})
    state = [5,1,2,8,9,3,6,4,7] |> Enum.reduce(initial, fn(x, acc) -> Model.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :draw

    initial = Model.init({:human_v_computer, :O, :player_2})
    state = [5,1,2,3,8] |> Enum.reduce(initial, fn(x, acc) -> Model.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :player_1_win

    initial = Model.init({:human_v_computer, :O, :player_1})
    state = [1,5,9,2,3,8] |> Enum.reduce(initial, fn(x, acc) -> Model.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :player_2_win
  end

  test "Controller.run_game runs a game to its terminus" do
    assert Controller.run_game(:computer_v_computer, FakeIO) == :draw
  end
end
