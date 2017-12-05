defmodule TicTacToe do
  @moduledoc """
  Tic Tac Toe Game
  """
  alias TicTacToe.Console.{Controller, Options}

  def run do
    Options.get() |> Controller.run_game()
  end
end
