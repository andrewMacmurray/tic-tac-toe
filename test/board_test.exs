defmodule BoardTest do
  use ExUnit.Case
  alias TicTacToe.Board
  alias BoardTestHelper, as: TestHelper

  test "Board.init returns a Board struct with a board with correct scale" do
    expected = %{
      1 => :empty, 2 => :empty, 3 => :empty,
      4 => :empty, 5 => :empty, 6 => :empty,
      7 => :empty, 8 => :empty, 9 => :empty
    }
    assert Board.init(3).tiles == expected

    expected = %{
      1  => :empty, 2  => :empty, 3  => :empty, 4  => :empty,
      5  => :empty, 6  => :empty, 7  => :empty, 8  => :empty,
      9  => :empty, 10 => :empty, 11 => :empty, 12 => :empty,
      13 => :empty, 14 => :empty, 15 => :empty, 16 => :empty,
    }
    assert Board.init(4).tiles == expected
  end

  test "Board.init returns Board struct with either default players or custom ones" do
    board = Board.init(3)
    assert board.player_1 == :X
    assert board.player_2 == :O

    board = Board.init(3, :O, :X)
    assert board.player_1 == :O
    assert board.player_2 == :X
  end

  test "Board.init returns a board with correct scale property" do
    scales = [ 3, 4, 5 ]
    for s <- scales do
      board = Board.init(s)
      assert board.scale == s
    end
  end

  test "Board.update should add a move for a given player to a board" do
    board =
      Board.init(3)
      |> Board.update(1, :player_1)
      |> Board.update(2, :player_2)

    %{1 => tile} = board.tiles
    assert tile == :X

    %{2 => tile} = board.tiles
    assert tile == :O
  end

  test "Board.empty_at? returns true if a given move is empty" do
    board =
      Board.init(3)
      |> Board.update(5, :player_1)
      |> Board.update(7, :player_2)

    assert Board.empty_at?(board, 1)
    refute Board.empty_at?(board, 5)
    refute Board.empty_at?(board, 7)
  end

  test "Board.possible_moves returns a list of possible moves" do
    moves = Board.init(3) |> Board.possible_moves()
    assert moves == Enum.to_list(1..9)
  end

  test "Board.moves returns the moves taken by a given player" do
    board = [1, 5, 9, 3] |> TestHelper.run_alternating_players(:player_1, Board.init(3))

    moves = board |> Board.moves(:player_1)
    assert moves == [1, 9]

    moves = board |> Board.moves(:player_2)
    assert moves == [3, 5]
  end

  test "Board.winning_states should return all winning states for a given board scale" do
    expected = [
      [1, 2, 3], [4, 5, 6], [7, 8, 9],
      [1, 4, 7], [2, 5, 8], [3, 6, 9],
      [1, 5, 9], [3, 5, 7]
    ]
    assert Board.winning_states(3) == expected

    expected = [
      [1,2,3,4],   [5,6,7,8],   [9,10,11,12], [13,14,15,16],
      [1,5,9,13],  [2,6,10,14], [3,7,11,15],  [4,8,12,16],
      [1,6,11,16], [4,7,10,13]
    ]
    assert Board.winning_states(4) == expected
  end

  test "Board.winner? should return false if the given player hasn't won" do
    p1_win = Board.init(3) |> Board.winner?(:player_1)
    assert p1_win == false

    p2_win = Board.init(3) |> Board.update(5, :player_2) |> Board.winner?(:player_2)
    assert p2_win == false
  end

  test "Board.winner? should return true if the given player has won" do
    for scale <-  [3, 4, 5],
        player <- [:player_1, :player_2] do
      win_boards =
        Board.winning_states(scale)
        |> TestHelper.add_player_to_states(player)
        |> Enum.map(fn mvs -> TestHelper.batch_update(mvs, Board.init(scale)) end)

      for b <- win_boards do
        assert Board.winner?(b, player)
      end
    end
  end

  test "Board.status should check if a game has reached a terminal state" do
    states = [
      {[5,1,2,6,8],         :player_1, :player_1_win},
      {[5,1,2,6,8],         :player_2, :player_2_win},
      {[5,1,2,8,7,3,9,4,6], :player_1, :draw},
      {[],                  :player_1, :non_terminal}
    ]
    for {sequence, first_player, expected} <- states do
      board  = sequence |> TestHelper.run_alternating_players(first_player, Board.init(3))
      actual = Board.status(board)
      assert actual == expected
    end
  end

  test "Board.full? returns true if all moves have been taken" do
    board =
      1..9
      |> Enum.to_list()
      |> TestHelper.run_alternating_players(:player_1, Board.init(3))
    assert Board.full?(board)
  end
end
