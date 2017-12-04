defmodule TicTacToe.AI do
  @moduledoc false
  alias TicTacToe.{Board, Minimax}

  @doc """
  Returns the best possible move for a given player
  """
  def run(board, ai_player) do
    moves_left = Board.possible_moves(board) |> length()
    case moves_left do
      9 -> take_center()
      8 -> counter_first_move(board)
      _ -> Minimax.best_move(board, ai_player)
    end
  end

  defp counter_first_move(board) do
    if Board.empty_at?(board, 5) do
      take_center()
    else
      take_corner()
    end
  end

  defp take_center, do: 5
  defp take_corner, do: 1
end
