defmodule TicTacToe.Minimax do
  @moduledoc false
  alias TicTacToe.Board

  @doc """
  Returns the best possible move for a given player via minimax algorithm
  """
  def best_move(board, ai_player) do
    {mv, _} =
      board
      |> Board.possible_moves()
      |> Enum.map(fn mv -> get_move_score(mv, board, ai_player) end)
      |> Enum.max_by(fn {_, score} -> score end)
    mv
  end

  defp get_move_score(move, board, ai_player) do
    board         = Board.update(board, move, ai_player)
    initial_depth = 1
    player_state  = {ai_player, false}
    {move, minimax(board, initial_depth, player_state)}
  end

  # the minimax algorithm follows each move to a terminal state
  # assigns moves a positive or negative score depending on player perspective
  # free codecamp article: https://goo.gl/Zd8eJh
  defp minimax(board, depth, {player, is_oponent} = ps) do
    win  = Board.winner?(board, player)
    cond do
      win && !is_oponent ->  1 / depth
      win && is_oponent  -> -1 / depth
      Board.full?(board) -> 0
      true               -> go_again(board, depth + 1, swap_player_state(ps))
    end
  end

  defp go_again(board, depth, {player, is_oponent} = ps) do
    move_scores =
      board
      |> Board.possible_moves()
      |> Enum.map(fn mv  -> Board.update(board, mv, player) end)
      |> Enum.map(fn brd -> minimax(brd, depth, ps) end)

    if is_oponent do
      Enum.min(move_scores)
    else
      Enum.max(move_scores)
    end
  end

  defp swap_player_state({player, is_oponent}) do
    {Board.swap_player(player), !is_oponent}
  end
end
