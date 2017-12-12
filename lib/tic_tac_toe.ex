defmodule TicTacToe do
  @moduledoc """
  Tic Tac Toe Game
  """
  alias TicTacToe.Console.{Game, Options}

  @doc """
  Entry function for command line executable
  """
  def main(_argv), do: run()

  @doc """
  Runs a Tic Tac Toe game
  """
  def run do
    Options.get() |> Game.run()
  end
end
