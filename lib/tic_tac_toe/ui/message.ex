defmodule TicTacToe.UI.Message do
  @moduledoc false
  def welcome, do: "Welcome to Tic Tac Toe! 👾  👾  👾"

  def divider, do: "----------------------------------"

  def game_types do
    [
      "Select a game to play:",
      "1. Human vs Human        💁  vs 💁",
      "2. Computer vs Computer  🤖  vs 🤖",
      "3. Human vs Computer     💁  vs 🤖"
    ]
  end

  def enter_option, do: "Please enter 1, 2 or 3:"
end
