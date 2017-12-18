defmodule TicTacToe.AI do
  @moduledoc false
  alias TicTacToe.Strategy.{ThreeByThree, FourByFour}

  @doc """
  Returns a strategic move for a given player based on the board scale
  """
  def run(board, ai_player) do
    case board.scale do
      3 -> ThreeByThree.strategy(board, ai_player)
      4 -> FourByFour.strategy(board, ai_player)
    end
  end
end
