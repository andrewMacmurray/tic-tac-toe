defmodule ControllerTest do
  use ExUnit.Case
  alias TicTacToe.Console.{Model, Controller}
  alias ModelTestHelper, as: TestHelper

  test "Controller.parse_guess! take a user guess and return a result" do
    expected = 3
    actual   = Controller.parse_guess!("3\n")
    assert actual == expected

    expected = :error
    actual = Controller.parse_guess!("hello?")
    assert actual == expected
  end

  test "Controller.init should print the initial model and return the model unmodified" do
    model = Model.init(:human_v_human)
    actual = Controller.init(model, FakeIO)
    assert actual == model

    model = Model.init(:computer_v_computer)
    actual = Controller.init(model, FakeIO)
    assert actual == model

    model = Model.init({:human_v_computer, :X, :player_1})
    actual = Controller.init(model, FakeIO)
    assert actual == model

    model = Model.init({:human_v_computer, :O, :player_2})
    actual = Controller.init(model, FakeIO)
    assert actual == model
  end

  test "Controller.handle_guess should take a game model for human_v_human,
        prompt the user for a guess
        and correctly update model" do
    model = Model.init(:human_v_human)
    guess = 5

    expected = Model.update(model, guess)
    actual   = Controller.handle_guess(model, {IOGuess5, FakeProcess})
    assert actual == expected
  end

  test "Controller.handle_guess should return the original model
        if an unrecognised guess is given" do
    original_model = Model.init(:human_v_human)

    actual = Controller.handle_guess(original_model, {IOGuessUnrecognized, FakeProcess})
    assert actual == original_model
  end

  test "If a move has already been taken should return the original model" do
    original_model = Model.init(:human_v_human) |> Model.update(5)
    actual = Controller.handle_guess(original_model, {IOGuess5, FakeProcess})

    assert actual == original_model
  end

  test "Controller.handle_guess should return a new model for a :computer_v_computer game" do
    initial_model = Model.init(:computer_v_computer)
    actual = Controller.handle_guess(initial_model, {FakeIO, FakeProcess})

    expected = Model.update(initial_model, 5)
    assert actual == expected
  end

  test "Controller.handle_guess should return a new model for a :human_v_computer game
        where human guesses first" do
    initial_model = Model.init({:human_v_computer, :X, :player_1})
    actual = Controller.handle_guess(initial_model, {IOGuess9, FakeProcess})
    expected = Model.update(initial_model, 9)
    assert actual == expected

    initial_model = Model.init({:human_v_computer, :X, :player_1})
    actual = Controller.handle_guess(initial_model, {IOGuessUnrecognized, FakeProcess})
    assert actual == initial_model

    initial_model =
      Model.init({:human_v_computer, :X, :player_1})
      |> TestHelper.sequence([5, 1])
    actual = Controller.handle_guess(initial_model, {IOGuess5, FakeProcess})
    assert actual == initial_model
  end

  test "Controller.handle_guess should return a new model for a :human_v_computer game
        where computer guesses first" do
    initial_model = Model.init({:human_v_computer, :O, :player_2})
    actual        = Controller.handle_guess(initial_model, {FakeIO, FakeProcess})

    expected = Model.update(initial_model, 5)
    assert actual == expected
  end


  test "Controller.terminus should print results and return status for human_v_human game" do
    model = Model.init(:human_v_human) |> TestHelper.sequence([5,1,2,4,8])
    actual = Controller.terminus(model, FakeIO)
    assert actual == :player_1_win

    model = Model.init(:human_v_human) |> TestHelper.sequence([5,1,2,8,9,3,6,4,7])
    actual = Controller.terminus(model, FakeIO)
    assert actual == :draw
  end

  test "Controller.terminus should print results and return status for computer_v_computer game" do
    model = Model.init(:computer_v_computer) |> TestHelper.sequence([5,1,2,4,8])
    actual = Controller.terminus(model, FakeIO)
    assert actual == :player_1_win

    model = Model.init(:computer_v_computer) |> TestHelper.sequence([5,1,2,8,9,3,6,4,7])
    actual = Controller.terminus(model, FakeIO)
    assert actual == :draw
  end

  test "Controller.terminus should print results and return status for human_v_computer game" do
    model = Model.init({:human_v_computer, :X, :player_1}) |> TestHelper.sequence([5,1,2,8,9,3,6,4,7])
    actual = Controller.terminus(model, FakeIO)
    assert actual == :draw

    model = Model.init({:human_v_computer, :O, :player_2}) |> TestHelper.sequence([5,1,2,3,8])
    actual = Controller.terminus(model, FakeIO)
    assert actual == :player_1_win

    model = Model.init({:human_v_computer, :O, :player_1}) |> TestHelper.sequence([1,5,9,2,3,8])
    actual = Controller.terminus(model, FakeIO)
    assert actual == :player_2_win
  end

  test "Controller.run_game runs a game to its terminus" do
    assert Controller.run_game(:computer_v_computer, {FakeIO, FakeProcess}) == :draw
  end
end
