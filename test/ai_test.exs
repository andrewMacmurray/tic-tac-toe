defmodule AiTest do
  use ExUnit.Case
  alias TicTacToe.{AI, Board}
  alias BoardTestHelper, as: TestHelper

  test "AI.run should take the center if not already taken" do
    result = %Board{} |> AI.run(:player_2)
    %{5 => tile} = result.tiles
    assert tile == :O

    result =
      %Board{}
      |> Board.update(1, :player_1)
      |> AI.run(:player_2)
    %{5 => tile} = result.tiles
    assert tile == :O
  end

  test "AI.run should take the corner if the center is already taken" do
    result =
      %Board{}
      |> Board.update(5, :player_1)
      |> AI.run(:player_2)
    %{1 => tile} = result.tiles
    assert tile == :O
  end

  test "AI.run should block an oponent about to win" do
    board = %Board{player_1: :X, player_2: :O}
    result =
      [5, 1, 3]
      |> TestHelper.run_alternating_players(:player_1, board)
      |> AI.run(:player_2)
    %{7 => tile} = result.tiles
    assert tile == :O

    result =
      [5, 1, 2]
      |> TestHelper.run_alternating_players(:player_1, board)
      |> AI.run(:player_2)
    %{8 => tile} = result.tiles
    assert tile == :O

    result =
      [5, 9, 3, 7]
      |> TestHelper.run_alternating_players(:player_2, board)
      |> AI.run(:player_2)
    %{8 => tile} = result.tiles
    assert tile == :O
  end

  test "brute force random play, player_1 should never win" do
    board     = %Board{player_1: :X, player_2: :O} |> Board.update(5, :player_2)
    ai_player = :player_2
    for _ <- 1..20 do
      # plays random moves against the AI until a terminal state has been reached
      final_board = TestHelper.play_to_the_death(board, ai_player)
      p1_win      = Board.winner?(final_board, :player_1)
      refute p1_win
    end
  end
end
