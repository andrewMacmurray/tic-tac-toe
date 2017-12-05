defmodule ModelTest do
  use ExUnit.Case
  alias TicTacToe.{Model, Board}
  alias BoardTestHelper, as: TestHelper

  test "Model.init should take a tuple of options for human_v_human and return a correct Model struct" do
    options  = {:human_v_human, :X, :player_1}
    actual   = Model.init(options)
    expected = %Model{
      game_type:   :human_v_human,
      board:       %Board{},
      next_player: :player_1,
      game_status: :non_terminal
    }
    assert actual == expected

    options = {:human_v_human, :O, :player_1}
    actual  = Model.init(options)
    expected = %Model{
      game_type:   :human_v_human,
      board:       %Board{player_1: :O, player_2: :X},
      next_player: :player_1,
      game_status: :non_terminal
    }
    assert actual == expected
  end

  test "Model.init should take a :computer_v_computer message and return a correct Model struct" do
    actual   = Model.init(:computer_v_computer)
    expected = %Model{
      game_type:   :computer_v_computer,
      board:       %Board{},
      next_player: :player_1,
      game_status: :non_terminal
    }
    assert actual == expected
  end

  test "Model.init should take a tuple of options for human_v_computer and return a correct Model struct" do
    options  = {:human_v_computer, :X, :player_1}
    actual   = Model.init(options)
    expected = %Model{
      game_type:   :human_v_computer,
      board:       %Board{},
      next_player: :player_1,
      ai_player:   :player_2,
      game_status: :non_terminal
    }
    assert actual == expected

    options = {:human_v_computer, :X, :player_2}
    actual  = Model.init(options)
    expected = %Model{
      game_type:   :human_v_computer,
      board:       %Board{player_1: :O, player_2: :X},
      next_player: :player_1,
      ai_player:   :player_1,
      game_status: :non_terminal
    }
    assert actual == expected
  end

  test "Model.update should take a guess for a human_v_human game and return correctly updated state" do
    current_state = %Model{
      game_type:   :human_v_human,
      board:       %Board{},
      next_player: :player_1,
      game_status: :non_terminal
    }
    actual = Model.update(current_state, 5)
    expected = %{
      current_state |
        next_player: :player_2,
        board:       Board.update(current_state.board, 5, :player_1)
    }
    assert actual == expected
  end

  test "Model.update should set the game_status to a terminal state when a player has won" do
    about_to_win = [5, 1, 2, 4] |> TestHelper.run_alternating_players(:player_1, %Board{})
    current_state = %Model{
      board:       about_to_win,
      next_player: :player_1,
      game_type:   :human_v_human,
      game_status: :non_terminal
    }

    expected_state = %Model{
      board:       Board.update(about_to_win, 8, :player_1),
      next_player: :player_2,
      game_type:   :human_v_human,
      game_status: :player_1_win
    }

    actual = Model.update(current_state, 8)
    assert expected_state == actual
  end

  test "Model.update should take a guess for a computer_v_computer game and return correctly updated state" do
    current_state = %Model{
      game_type:   :computer_v_computer,
      board:       %Board{},
      next_player: :player_1,
      game_status: :non_terminal
    }
    actual = Model.update(current_state, 5)
    expected = %{
      current_state |
        next_player: :player_2,
        board:       Board.update(current_state.board, 5, :player_1)
    }
    assert actual == expected
  end

  test "Model.update should take a guess for a human_v_computer game and return correctly updated state" do
    current_state = %Model{
      game_type:   :human_v_computer,
      board:       %Board{},
      next_player: :player_1,
      ai_player:   :player_2,
      game_status: :non_terminal
    }
    actual = Model.update(current_state, 1)
    expected = %{
      current_state |
        next_player: :player_2,
        board:       Board.update(current_state.board, 1, :player_1)
    }
    assert actual == expected
  end
end
