defmodule ConsoleBoardTest do
  use ExUnit.Case
  alias TicTacToe.Console.Board, as: Console
  alias TicTacToe.Board
  alias BoardTestHelper, as: TestHelper

  test "Console.render_tile should render an individual tile" do
    tiles = [
      {{3, :empty}, "3"},
      {{1, :X},     "X"},
      {{2, :O},     "O"}
    ]
    for {tile, expected} <- tiles do
      assert Console.render_tile(tile) == expected
    end
  end

  test "Console.render_row should render a row correctly" do
    row = [{1, :X}, {2, :O}, {3, :empty}]
    expected = "   X   O   3"
    assert Console.render_row(row) == expected
  end

  test "Console.render_board should render a board correctly" do
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
    assert Console.render_board(%Board{}) == expected

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
    assert Console.render_board(board) == expected
  end

  test "Console.move_summary should render human_v_human players correctly" do
    expected = """
    Player 1 took tile 3
    Your turn Player 2
    """
    |> String.trim()
    tile = {3, :X}
    assert Console.move_summary(:human_v_human, tile, %Board{}) == expected

    expected = """
    Player 2 took tile 3
    Your turn Player 1
    """
    |> String.trim()
    tile = {3, :O}
    assert Console.move_summary(:human_v_human, tile, %Board{}) == expected
  end

  test "Console.move_summary should render computer_v_computer players correctly" do
    expected = """
    Player 1 took tile 5
    Your turn Player 2
    """
    |> String.trim()
    tile = {5, :X}
    assert Console.move_summary(:computer_v_computer, tile, %Board{}) == expected

    expected = """
    Player 2 took tile 7
    Your turn Player 1
    """
    |> String.trim()
    tile = {7, :O}
    assert Console.move_summary(:computer_v_computer, tile, %Board{}) == expected
  end

  test "Console.move_summary should render human_v_computer players correctly" do
    expected = """
    Ok, I'll take tile 5
    Your turn
    """
    |> String.trim()
    tile = {5, :O}
    assert Console.move_summary(:human_v_computer, tile, %Board{}) == expected
  end
end
