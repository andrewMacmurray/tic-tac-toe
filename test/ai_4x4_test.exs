defmodule AiFourByFourTest do
  use ExUnit.Case
  alias TicTacToe.{AI, Board}
  alias BoardTestHelper, as: TestHelper

  test "AI.take_center_four should take a center piece if not already taken" do
    result = Board.init(4) |> AI.run(:player_2)
    assert result == 6

    player_moves = [
      {6,  7},
      {7,  6},
      {10, 6},
      {11, 6}
    ]
    for {p1_move, ai_move} <- player_moves do
      result = Board.init(4) |> Board.update(p1_move, :player_1) |> AI.take_center_four()
      assert result == ai_move
    end
  end

  test "AI.find_promising_oponent_move should look for an oponent move at least 2 tiles long" do
    sequences = [
      {[5],           :no_move},
      {[1, 2],        %{win_state: [1,2,3,4], move: [1,2]}},
      {[6, 7],        %{win_state: [5,6,7,8], move: [6, 7]}},
      {[2, 5, 9, 11], %{win_state: [9,10,11,12], move: [9, 11]}},
      {[2, 10],       %{win_state: [2,6,10,14], move: [2, 10]}}
    ]
    for {seq, expected} <- sequences do
      result =
        seq
        |> List.foldl(Board.init(4), fn(mv, b) -> Board.update(b, mv, :player_1) end)
        |> AI.find_promising_oponent_move(:player_2)
      assert result == expected
    end
  end

  test "AI.find_promising_oponent_move should return the move if the remaining tiles aren't already taken by the ai" do
    sequences = [
      {[1, 2],        [],     %{win_state: [1,2,3,4], move: [1,2]}},
      {[1, 2],        [3],    :no_move},
      {[1, 2],        [4],    :no_move},
      {[1, 2],        [3, 4], :no_move},
      {[2, 5, 9, 11], [],     %{win_state: [9,10,11,12], move: [9, 11]}},
      {[2, 5, 9, 11], [13],   %{win_state: [9,10,11,12], move: [9, 11]}},
      {[1, 5, 3, 7],  [9],    %{win_state: [1,2,3,4], move: [1,3]}},
    ]
    for {oponent_seq, ai_seq, expected} <- sequences do
      b1 = oponent_seq |> List.foldl(Board.init(4), fn(mv, b) -> Board.update(b, mv, :player_1) end)
      b2 = ai_seq |> List.foldl(b1, fn(mv, b) -> Board.update(b, mv, :player_2) end)
      result = AI.find_promising_oponent_move(b2, :player_2)
      assert result == expected
    end
  end

  test "AI.block_promising_move should return a blocking move to an oponents promising move" do
    sequences = [
      {[1, 2],        [],   3},
      {[1, 5],        [],   9},
      {[1, 4],        [],   2},
      {[2, 5, 9, 11], [13], 10},
      {[1,2],         [3],  :no_move},
      {[1,2,10],      [3],  6}
    ]
    for {oponent_seq, ai_seq, expected} <- sequences do
      b1 = oponent_seq |> List.foldl(Board.init(4), fn(mv, b) -> Board.update(b, mv, :player_1) end)
      b2 = ai_seq |> List.foldl(b1, fn(mv, b) -> Board.update(b, mv, :player_2) end)
      result = AI.block_promising_move(b2, :player_2)
      assert result == expected
    end
  end

  test "AI.find_dangerous_oponent_move should find a move where the oponent has 3 tiles lined up" do
    sequences = [
      {[1,3,4,7,13],  %{win_state: [1,2,3,4], move: [1,3,4]}},
      {[3,4,7,13],    %{win_state: [4,7,10,13], move: [4,7,13]}}
    ]
    for {seq, expected} <- sequences do
      result =
        seq
        |> List.foldl(Board.init(4), fn(mv, b) -> Board.update(b, mv, :player_1) end)
        |> AI.find_dangerous_oponent_move(:player_2)
      assert result == expected
    end
  end

  test "AI.find_dangerous_oponent_move should only return the move if the ai hasn't taken the final piece" do
    sequences = [
      {[1,3,4,7],   [],   %{win_state: [1,2,3,4], move: [1,3,4]}},
      {[2,6,10],    [14], :no_move},
      {[1,3,4,7],   [2],  :no_move},
      {[1,2,3,5,9], [4],  %{win_state: [1,5,9,13], move: [1,5,9]}}
    ]
    for {oponent_seq, ai_seq, expected} <- sequences do
      b1 = oponent_seq |> List.foldl(Board.init(4), fn(mv, b) -> Board.update(b, mv, :player_1) end)
      b2 = ai_seq |> List.foldl(b1, fn(mv, b) -> Board.update(b, mv, :player_2) end)
      result = AI.find_dangerous_oponent_move(b2, :player_2)
      assert result == expected
    end
  end

  test "AI.block_dangerous_move should return a blocking move to an oponent's dangerous move" do
    sequences = [
      {[1,3,4,7],   [],   2},
      {[1,2,3,5,9], [4],  13},
      {[2,6,10],    [14], :no_move}
    ]
    for {oponent_seq, ai_seq, expected} <- sequences do
      b1 = oponent_seq |> List.foldl(Board.init(4), fn(mv, b) -> Board.update(b, mv, :player_1) end)
      b2 = ai_seq |> List.foldl(b1, fn(mv, b) -> Board.update(b, mv, :player_2) end)
      result = AI.block_dangerous_move(b2, :player_2)
      assert result == expected
    end
  end

  test "AI.add_to_existing_move should return a move to add to an existing move" do
    sequences = [
      {[1],     2},
      {[1,2],   3},
      {[1,3,4], 2},
      {[4,7],   10}
    ]
    for {ai_seq, expected} <- sequences do
      result =
        ai_seq
        |> List.foldl(Board.init(4), fn(mv, b) -> Board.update(b, mv, :player_2) end)
        |> AI.add_to_existing_move(:player_2)
      assert result == expected
    end
  end

  test "AI.add_to_existing_move should only return moves where spaces still exist" do
    sequences = [
      {[1],      [2],        6},
      {[2],      [4],        8},
      {[10, 16], [4],        1},
      {[11],     [2,3,4,14], 1}
    ]
    for {oponent_seq, ai_seq, expected} <- sequences do
      b1 = oponent_seq |> List.foldl(Board.init(4), fn(mv, b) -> Board.update(b, mv, :player_1) end)
      b2 = ai_seq |> List.foldl(b1, fn(mv, b) -> Board.update(b, mv, :player_2) end)
      result = AI.add_to_existing_move(b2, :player_2)
      assert result == expected
    end
  end

  test "AI.aggressively_block combines three strategies in order of importance" do
    sequences = [
      {[1,2,3], [],  4},
      {[5,6],   [],  7},
      {[1,2],   [3], 7}
    ]
    for {oponent_seq, ai_seq, expected} <- sequences do
      b1 = oponent_seq |> List.foldl(Board.init(4), fn(mv, b) -> Board.update(b, mv, :player_1) end)
      b2 = ai_seq |> List.foldl(b1, fn(mv, b) -> Board.update(b, mv, :player_2) end)
      result = AI.aggressively_block(b2, :player_2)
      assert result == expected
    end
  end

  test "brute force random play, player_1 should never win for 4x4 grid" do
    board     = Board.init(4) |> Board.update(5, :player_2)
    ai_player = :player_2
    for _ <- 1..50 do
      # plays random moves against the AI until a terminal state has been reached
      final_board = TestHelper.play_to_the_death(board, ai_player)
      p1_win      = Board.winner?(final_board, :player_1)
      refute p1_win
    end
  end

  test "AI vs AI should always result in a draw" do
    board = Board.init(4)
    xs    = Enum.to_list(1..16)
    res = List.foldl(xs, board, fn(i, b) ->
      cond do
        TestHelper.terminal?(b) -> b
        rem(i, 2) == 0          -> Board.update(b, AI.run(b, :player_2), :player_2)
        true                    -> Board.update(b, AI.run(b, :player_1), :player_1)
      end
    end)
    assert Board.status(res) == :draw
  end
end
