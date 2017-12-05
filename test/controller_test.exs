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

  test "Controller.handle_init should print the initial state and return the state unmodified" do
    state = State.init({:human_v_human, :X, :player_1})
    actual = Controller.handle_init(state, FakeIO)
    assert actual == state

    state = State.init(:computer_v_computer)
    actual = Controller.handle_init(state, FakeIO)
    assert actual == state

    state = State.init({:human_v_computer, :X, :player_1})
    actual = Controller.handle_init(state, FakeIO)
    assert actual == state

    state = State.init({:human_v_computer, :O, :player_2})
    actual = Controller.handle_init(state, FakeIO)
    assert actual == state
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

  test "Controller.handle_terminus shoud pass state through unmodified if not in terminal state" do
    state = State.init({:human_v_human, :X, :player_1})
    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == state

    state = State.init(:computer_v_computer)
    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == state

    state = State.init({:human_v_computer, :O, :player_2})
    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == state
  end

  test "Controller.handle_terminus should handle and return terminal state for human_v_human game" do
    initial = State.init({:human_v_human, :X, :player_1})
    state = [5,1,2,4,8] |> Enum.reduce(initial, fn(x, acc) -> State.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :player_1_win

    initial = State.init({:human_v_human, :X, :player_1})
    state = [5,1,2,8,9,3,6,4,7] |> Enum.reduce(initial, fn(x, acc) -> State.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :draw
  end

  test "Controller.handle_terminus should handle and return terminal state for computer_v_computer game" do
    initial = State.init(:computer_v_computer)
    state = [5,1,2,4,8] |> Enum.reduce(initial, fn(x, acc) -> State.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :player_1_win

    initial = State.init(:computer_v_computer)
    state = [5,1,2,8,9,3,6,4,7] |> Enum.reduce(initial, fn(x, acc) -> State.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :draw
  end

  test "Controller.handle_terminus should handle and return terminal state for human_v_computer game" do
    initial = State.init({:human_v_computer, :X, :player_1})
    state = [5,1,2,8,9,3,6,4,7] |> Enum.reduce(initial, fn(x, acc) -> State.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :draw

    initial = State.init({:human_v_computer, :O, :player_2})
    state = [5,1,2,3,8] |> Enum.reduce(initial, fn(x, acc) -> State.update(acc, x) end)

    actual = Controller.handle_terminus(state, FakeIO)
    assert actual == :player_1_win
  end
end
