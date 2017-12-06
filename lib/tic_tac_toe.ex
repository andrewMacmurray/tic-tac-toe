defmodule TicTacToe do
  @moduledoc """
  Tic Tac Toe Game
  """
  alias TicTacToe.Console.{Controller, Options}

  @doc """
  Entry function for command line executable
  """
  def main(_argv), do: run()

  @doc """
  Runs a Tic Tac Toe game
  """
  def run do
    Options.get() |> Controller.run_game()
  end
end
