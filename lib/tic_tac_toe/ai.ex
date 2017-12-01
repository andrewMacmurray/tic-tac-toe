defmodule TicTacToe.AI do
  @moduledoc false
  alias TicTacToe.{Board, Minimax}

  @doc """
  Updates the board with the best possible move for a given player
  """
  def run(board, ai_player) do
    mvs = Board.possible_moves(board) |> length()
    case mvs do
      9 -> take_center(board, ai_player)
      8 -> counter_first_move(board, ai_player)
      _ -> run_minimax(board, ai_player)
    end
  end

  def counter_first_move(board, player) do
    if Board.empty_at?(board, 5) do
      take_center(board, player)
    else
      take_corner(board, player)
    end
  end

  def run_minimax(board, ai_player) do
    mv = Minimax.best_move(board, ai_player)
    Board.update(board, mv, ai_player)
  end

  def take_center(board, player), do: Board.update(board, 5, player)
  def take_corner(board, player), do: Board.update(board, 1, player)
end
