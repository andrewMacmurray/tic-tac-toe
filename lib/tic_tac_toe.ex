defmodule TicTacToe do
  @moduledoc """
  Tic Tac Toe Game
  """
  alias TicTacToe.Console.{Controller, Options}

  @doc """
  Runs a Tic Tac Toe game
  """
  def run do
    Options.get() |> Controller.run_game()
  end
end
