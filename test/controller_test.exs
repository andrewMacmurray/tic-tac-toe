defmodule ControllerTest do
  use ExUnit.Case
  alias TicTacToe.{Controller, State}

  test "Controller.parse_guess! take a user guess and return a result" do
    expected = 3
    actual   = Controller.parse_guess!("3\n")
    assert actual == expected

    expected = :error
    actual = Controller.parse_guess!("hello?")
    assert actual == expected
  end

  test "Controller.handle_guess should take a game state for human_v_human,
        prompt the user for a guess
        and correctly update state" do
    state = State.init({:human_v_human, :X, :player_1})
    guess = 5

    expected = State.update(state, guess)
    actual   = Controller.handle_guess(state, FakeIO3)
    assert actual == expected
  end

  test "Controller.handle_guess should return the original state
        if an unrecognised guess is given" do
    original_state = State.init({:human_v_human, :X, :player_1})

    actual = Controller.handle_guess(original_state, FakeIO6)
    assert actual == original_state
  end

  test "If a move has already been taken should return the original state" do
    original_state = State.init({:human_v_human, :X, :player_1}) |> State.update(5)
    actual = Controller.handle_guess(original_state, FakeIO3)

    assert actual == original_state
  end

  test "Controller.handle_guess should return a new state for a :computer_v_computer game" do
    initial_state = State.init(:computer_v_computer)
    actual = Controller.handle_guess(initial_state, FakeIO)

    expected = State.update(initial_state, 5)
    assert actual == expected
  end

  test "Controller.handle_guess should return a new state for a :human_v_computer game
        where human guesses first" do
    initial_state = State.init({:human_v_computer, :X, :player_1})
    actual = Controller.handle_guess(initial_state, FakeIO5)

    expected = State.update(initial_state, 9)
    assert actual == expected
  end

  test "Controller.handle_guess should return a new state for a :human_v_computer game
        where computer guesses first" do
    initial_state = State.init({:human_v_computer, :O, :player_2})
    actual = Controller.handle_guess(initial_state, FakeIO5)

    expected = State.update(initial_state, 5)
    assert actual == expected
  end
end
