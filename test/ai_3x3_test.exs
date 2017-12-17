defmodule AiThreeByThreeTest do
  use ExUnit.Case
  alias TicTacToe.{AI, Board}
  alias BoardTestHelper, as: TestHelper

  test "for 3x3 grid AI.run should take the center if not already taken" do
    result = Board.init(3) |> AI.run(:player_2)
    assert result == 5

    result =
      Board.init(3)
      |> Board.update(1, :player_1)
      |> AI.run(:player_2)
    assert result == 5
  end

  test "for 3x3 grid AI.run should take the corner if the center is already taken" do
    result =
      Board.init(3)
      |> Board.update(5, :player_1)
      |> AI.run(:player_2)
    assert result == 1
  end

  test "for 3x3 grid AI.run should block an oponent about to win" do
    board = Board.init(3)
    states = [
      {[5, 1, 3],    7},
      {[5, 1, 2],    8},
      {[5, 9, 3, 7], 8}
    ]
    for {sequence, expected_guess} <- states do
      result =
        sequence
        |> TestHelper.run_alternating_players(:player_1, board)
        |> AI.run(:player_2)
      assert result == expected_guess
    end
  end

  test "brute force random play, player_1 should never win for 3x3 grid" do
    board     = Board.init(3) |> Board.update(5, :player_2)
    ai_player = :player_2
    for _ <- 1..100 do
      # plays random moves against the AI until a terminal state has been reached
      final_board = TestHelper.play_to_the_death(board, ai_player)
      p1_win      = Board.winner?(final_board, :player_1)
      refute p1_win
    end
  end
end
