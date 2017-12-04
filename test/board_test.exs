defmodule BoardTest do
  use ExUnit.Case
  alias TicTacToe.Board
  alias BoardTestHelper, as: TestHelper

  test "Board struct should contain an empty board" do
    expected = %{
      1 => :empty, 2 => :empty, 3 => :empty,
      4 => :empty, 5 => :empty, 6 => :empty,
      7 => :empty, 8 => :empty, 9 => :empty
    }
    assert %Board{}.tiles == expected
  end

  test "Board struct should contain :player_1 and :player_2 with defaults" do
    board = %Board{}
    assert board.player_1 == :X
    assert board.player_2 == :O
  end

  test "Board.update should add a move for a given player to a board" do
    board =
      %Board{}
      |> Board.update(1, :player_1)
      |> Board.update(2, :player_2)

    %{1 => tile} = board.tiles
    assert tile == :X

    %{2 => tile} = board.tiles
    assert tile == :O
  end

  test "Board.empty_at? returns true if a given move is empty" do
    board =
      %Board{}
      |> Board.update(5, :player_1)
      |> Board.update(7, :player_2)

    assert Board.empty_at?(board, 1)
    refute Board.empty_at?(board, 5)
    refute Board.empty_at?(board, 7)
  end

  test "Board.possible_moves returns a list of possible moves" do
    moves = %Board{} |> Board.possible_moves()
    assert moves == Enum.to_list(1..9)
  end

  test "Board.moves returns the moves taken by a given player" do
    board = [1, 5, 9, 3] |> TestHelper.run_alternating_players(:player_1, %Board{})

    moves = board |> Board.moves(:player_1)
    assert moves == [1, 9]

    moves = board |> Board.moves(:player_2)
    assert moves == [3, 5]
  end

  test "Board.winner? should return false if the given player hasn't won" do
    p1_win = %Board{} |> Board.winner?(:player_1)
    assert p1_win == false

    p2_win = %Board{} |> Board.update(5, :player_2) |> Board.winner?(:player_2)
    assert p2_win == false
  end

  test "Board.winner? should return true if the given player has won" do
    winning_states = [
      [1, 2, 3], [4, 5, 6], [7, 8, 9],
      [1, 4, 7], [2, 5, 8], [3, 6, 9],
      [1, 5, 9], [3, 5, 7]
    ]

    p1_win_boards =
      winning_states
      |> TestHelper.add_player_to_states(:player_1)
      |> Enum.map(fn mvs -> TestHelper.batch_update(mvs, %Board{}) end)

    for b <- p1_win_boards do
      p1_win = Board.winner?(b, :player_1)
      assert p1_win
    end

    p2_win_boards =
      winning_states
      |> TestHelper.add_player_to_states(:player_2)
      |> Enum.map(fn mvs -> TestHelper.batch_update(mvs, %Board{}) end)

    for b <- p2_win_boards do
      p2_win = Board.winner?(b, :player_2)
      assert p2_win
    end
  end

  test "Board.game_status should check if a game has reached a terminal state" do
    p1_win_board = [5,1,2,6,8] |> TestHelper.run_alternating_players(:player_1, %Board{})
    actual   = Board.game_status(p1_win_board)
    assert actual == :player_1_win

    p2_win_board = [5,1,2,6,8] |> TestHelper.run_alternating_players(:player_2, %Board{})
    actual   = Board.game_status(p2_win_board)
    assert actual == :player_2_win

    draw_board = [5,1,2,8,7,3,9,4,6] |> TestHelper.run_alternating_players(:player_1, %Board{})
    actual = Board.game_status(draw_board)
    assert actual == :draw

    actual = Board.game_status(%Board{})
    assert actual == :non_terminal
  end

  test "Board.full? returns true if all moves have been taken" do
    board =
      1..9
      |> Enum.to_list()
      |> TestHelper.run_alternating_players(:player_1, %Board{})
    assert Board.full?(board)
  end
end
