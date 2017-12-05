defmodule ConsoleRenderTest do
  use ExUnit.Case
  alias TicTacToe.Console.Render
  alias TicTacToe.Board
  alias BoardTestHelper, as: TestHelper

  test "Render.render_tile should render an individual tile" do
    tiles = [
      {{3, :empty}, "3"},
      {{1, :X},     "X"},
      {{2, :O},     "O"}
    ]
    for {tile, expected} <- tiles do
      assert Render.render_tile(tile) == expected
    end
  end

  test "Render.render_row should render a row correctly" do
    row = [{1, :X}, {2, :O}, {3, :empty}]
    expected = "   X   O   3"
    assert Render.render_row(row) == expected
  end

  test "Render.render_board should render a board correctly" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    """
    |> String.trim()
    assert Render.render_board(%Board{}) == expected

    expected = """
    ---------------
       X   X   3
    ---+---+---+---
       4   O   6
    ---+---+---+---
       7   8   9
    ---------------
    """
    |> String.trim()
    board =
      [1, 5, 2] |> TestHelper.run_alternating_players(:player_1, %Board{})
    assert Render.render_board(board) == expected
  end

  test "Render.move_summary should render human_v_human players correctly" do
    expected = """
    Player 1 took tile 3
    Your turn Player 2
    """
    |> String.trim()
    assert Render.move_summary(:human_v_human, 3, :player_1) == expected

    expected = """
    Player 2 took tile 3
    Your turn Player 1
    """
    |> String.trim()
    assert Render.move_summary(:human_v_human, 3, :player_2) == expected
  end

  test "Render.move_summary should render computer_v_computer players correctly" do
    expected = """
    Player 1 took tile 5
    Your turn Player 2
    """
    |> String.trim()
    assert Render.move_summary(:computer_v_computer, 5, :player_1) == expected

    expected = """
    Player 2 took tile 7
    Your turn Player 1
    """
    |> String.trim()
    assert Render.move_summary(:computer_v_computer, 7, :player_2) == expected
  end

  test "Render.move_summary should render human_v_computer players correctly" do
    expected = """
    Ok, I'll take tile 5
    Your turn
    """
    |> String.trim()
    human_player = :player_1
    ai_player    = :player_2
    assert Render.move_summary(:human_v_computer, 5, ai_player, ai_player) == expected

    expected = """
    You took tile 5
    Ok, I'll go next
    """
    |> String.trim()
    assert Render.move_summary(:human_v_computer, 5, ai_player, human_player) == expected
  end

  test "Render.init_message should show first board and instructions for human_v_human" do
    actual = Render.init_message(:human_v_human, %Board{}, :player_1)
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    Your turn Player 1
    """
    |> String.trim()
    assert actual == expected
  end

  test "Render.init_message should show first board and instructions for computer_v_computer" do
    actual = Render.init_message(:computer_v_computer, %Board{}, :player_1)
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    Your turn Player 1
    """
    |> String.trim()
    assert actual == expected
  end

  test "Render.init_message should show first board and instructions for human_v_computer" do
    actual = Render.init_message(:human_v_computer, %Board{}, :player_1)
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    Your turn
    """
    |> String.trim()
    assert actual == expected
  end

  test "Render.init_message should show nothing if computer goes first" do
    actual = Render.init_message(:human_v_computer, %Board{}, :player_2)
    assert actual == ""
  end

  test "Render.render_change should render the board and a summary of the move made" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   9
    ---------------
    Player 1 took tile 5
    Your turn Player 2
    """
    |> String.trim()
    guess  = 5
    player = :player_1
    board  = %Board{} |> Board.update(guess, player)
    assert Render.render_change(:human_v_human, board, guess, player) == expected
  end

  test "Render.render_change should render the board and a summary of the move made in a human_v_computer game" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   9
    ---------------
    You took tile 5
    Ok, I'll go next
    """
    |> String.trim()
    guess  = 5
    human_player = :player_1
    ai_player    = :player_2
    board  = %Board{} |> Board.update(guess, human_player)
    assert Render.render_change(:human_v_computer, board, guess, human_player, ai_player) == expected
  end

  test "Render.render_final should render the result of a final human_v_human game" do
    expected = """
    ---------------
       X   O   O
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   X
    ---------------
    Player 1 won!
    """
    |> String.trim()
    board = [5,2,1,3,9] |> TestHelper.run_alternating_players(:player_1, %Board{})
    assert Render.render_final(:human_v_human, board) == expected
  end
end
