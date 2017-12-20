defmodule TicTacToe.Strategy.ThreeByThree do
  @moduledoc false
  alias TicTacToe.Board
  alias TicTacToe.Strategy.Minimax

  @center 5
  @corner 1

  @doc """
  AI strategy for a 3x3 game
  """
  def strategy(board, ai_player) do
    moves_left = Board.possible_moves(board) |> length()
    case moves_left do
      9 -> @center
      8 -> counter_first_move_three(board)
      _ -> Minimax.best_move(board, ai_player)
    end
  end

  defp counter_first_move_three(board) do
    if Board.empty_at?(board, @center) do @center else @corner end
  end
end
