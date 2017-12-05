defmodule TicTacToe do
  @moduledoc """
  Tic Tac Toe Game
  """
  alias TicTacToe.Controller
  alias TicTacToe.Console.Options

  def run do
    Options.get() |> Controller.run_game()
  end
end
