defmodule TicTacToe.Console.Util do
  @moduledoc false

  @doc """
  Helper to join lists of strings into renderable lines
  """
  def join_lines(xs), do: Enum.join(xs, "\n")
end
