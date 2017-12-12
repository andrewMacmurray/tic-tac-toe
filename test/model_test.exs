defmodule ModelTest do
  use ExUnit.Case
  alias TicTacToe.Board
  alias TicTacToe.Console.Model
  alias BoardTestHelper, as: TestHelper

  test "Model.init should return correct Model struct for human_v_human game" do
    actual   = Model.init(:human_v_human)
    expected = %Model{
      game_type:   :human_v_human,
      board:       %Board{}
    }
    assert actual == expected
  end

  test "Model.init should take a :computer_v_computer message and return a correct Model struct" do
    actual   = Model.init(:computer_v_computer)
    expected = %Model{
      game_type:   :computer_v_computer,
      board:       %Board{}
    }
    assert actual == expected
  end

  test "Model.init should take a tuple of options for human_v_computer and return a correct Model struct" do
    options  = {:human_v_computer, :X, :player_1}
    actual   = Model.init(options)
    expected = %Model{
      game_type:   :human_v_computer,
      board:       %Board{},
      ai_player:   :player_2
    }
    assert actual == expected

    options = {:human_v_computer, :X, :player_2}
    actual  = Model.init(options)
    expected = %Model{
      game_type:   :human_v_computer,
      board:       %Board{player_1: :O, player_2: :X},
      ai_player:   :player_1
    }
    assert actual == expected
  end

  test "Model.update should take a guess for a human_v_human game and return correctly updated model" do
    current_model = %Model{
      game_type:   :human_v_human,
      board:       %Board{}
    }
    actual = Model.update(current_model, 5)
    expected = %{
      current_model |
        next_player: :player_2,
        board:       Board.update(current_model.board, 5, :player_1)
    }
    assert actual == expected
  end

  test "Model.update should set the game_status to a terminal model when a player has won" do
    about_to_win = [5, 1, 2, 4] |> TestHelper.run_alternating_players(:player_1, %Board{})
    current_model = %Model{
      board:       about_to_win,
      next_player: :player_1,
      game_type:   :human_v_human
    }

    expected_model = %Model{
      board:       Board.update(about_to_win, 8, :player_1),
      next_player: :player_2,
      game_type:   :human_v_human,
      game_status: :player_1_win
    }

    actual = Model.update(current_model, 8)
    assert expected_model == actual
  end

  test "Model.update should take a guess for a computer_v_computer game and return correctly updated model" do
    current_model = %Model{
      game_type:   :computer_v_computer,
      board:       %Board{}
    }
    actual = Model.update(current_model, 5)
    expected = %{
      current_model |
        next_player: :player_2,
        board:       Board.update(current_model.board, 5, :player_1)
    }
    assert actual == expected
  end

  test "Model.update should take a guess for a human_v_computer game and return correctly updated model" do
    current_model = %Model{
      game_type:   :human_v_computer,
      board:       %Board{},
      ai_player:   :player_2
    }
    actual = Model.update(current_model, 1)
    expected = %{
      current_model |
        next_player: :player_2,
        board:       Board.update(current_model.board, 1, :player_1)
    }
    assert actual == expected
  end
end
