defmodule GameTest do
  use ExUnit.Case
  alias TicTacToe.Console.{Model, Game}
  alias ModelTestHelper, as: TestHelper

  test "Game.parse_guess! take a user guess and return a result" do
    guesses = [
      {"3\n",    3},
      {"hello?", :error}
    ]
    for {guess, expected} <- guesses do
      assert Game.parse_guess!(guess) == expected
    end
  end

  test "Game.init should print the initial model and return the model unmodified" do
    init_options = [
      :human_v_human,
      :computer_v_computer,
      {:human_v_computer, :X, :player_1},
      {:human_v_computer, :O, :player_2}
    ]
    for option <- init_options do
      initial_model = Model.init(option)
      actual        = Game.init(initial_model, FakeIO)
      assert actual == initial_model
    end
  end

  test "Game.handle_guess should take a game model for human_v_human,
        prompt the user for a guess
        and correctly update model" do
    model = Model.init(:human_v_human)
    guess = 5

    expected = Model.update(model, guess)
    actual   = Game.handle_guess(model, {IOGuess5, FakeProcess})
    assert actual == expected
  end

  test "Game.handle_guess should return the original model
        if an unrecognised guess is given" do
    original_model = Model.init(:human_v_human)

    actual = Game.handle_guess(original_model, {IOGuessUnrecognized, FakeProcess})
    assert actual == original_model
  end

  test "If a move has already been taken should return the original model" do
    original_model = Model.init(:human_v_human) |> Model.update(5)
    actual = Game.handle_guess(original_model, {IOGuess5, FakeProcess})

    assert actual == original_model
  end

  test "Game.handle_guess should return a new model for a :computer_v_computer game" do
    initial_model = Model.init(:computer_v_computer)
    actual = Game.handle_guess(initial_model, {FakeIO, FakeProcess})

    expected = Model.update(initial_model, 5)
    assert actual == expected
  end

  test "Game.handle_guess should return a new model for a :human_v_computer game
        where human guesses first" do
    fp            = FakeProcess
    initial_model = Model.init({:human_v_computer, :X, :player_1})
    updated_model = initial_model |> TestHelper.sequence([5, 1])
    states = [
      {{IOGuess9, fp},            initial_model, [9]},
      {{IOGuess5, fp},            initial_model, [5]},
      {{IOGuessUnrecognized, fp}, initial_model, []},
      {{IOGuess5, fp},            updated_model, [5, 1]}
    ]
    for {effect_modules, current_model, guesses} <- states do
      actual   = Game.handle_guess(current_model, effect_modules)
      expected = current_model |> TestHelper.sequence(guesses)
      assert actual == expected
    end
  end

  test "Game.handle_guess should return a new model for a :human_v_computer game
        where computer guesses first" do
    initial_model = Model.init({:human_v_computer, :O, :player_2})
    actual        = Game.handle_guess(initial_model, {FakeIO, FakeProcess})

    expected = Model.update(initial_model, 5)
    assert actual == expected
  end

  test "Game.terminus should print results and return status
        for each type of game" do
    win_seq   = [5,1,2,4,8]
    win_seq_2 = [1,5,9,2,3,8]
    draw_seq  = [5,1,2,8,9,3,6,4,7]
    games = [
      {:human_v_human,                     win_seq,   :player_1_win},
      {:human_v_human,                     win_seq_2, :player_2_win},
      {:human_v_human,                     draw_seq,  :draw},
      {:computer_v_computer,               win_seq,   :player_1_win},
      {:computer_v_computer,               win_seq_2, :player_2_win},
      {:computer_v_computer,               draw_seq,  :draw},
      {{:human_v_computer, :O, :player_2}, win_seq,   :player_1_win},
      {{:human_v_computer, :O, :player_1}, win_seq_2, :player_2_win},
      {{:human_v_computer, :X, :player_1}, draw_seq,  :draw}
    ]
    for {game_options, sequence, expected} <- games do
      model  = Model.init(game_options) |> TestHelper.sequence(sequence)
      actual = Game.terminus(model, FakeIO)
      assert actual == expected
    end
  end

  test "Game.run runs a game to its terminus" do
    assert Game.run(:computer_v_computer, {FakeIO, FakeProcess}) == :draw
  end
end
