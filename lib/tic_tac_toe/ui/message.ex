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

  def enter_game_option, do: "Enter 1, 2 or 3: "

  def vs_computer_tile_symbol, do: "Ok, which tile Symbol would you like?"

  def vs_human_tile_symbol, do: "Ok Player 1, which tile Symbol would you like?"

  def enter_tile_symbol, do: "Enter X or O: "

  def player, do: "Would you like to go first?"

  def yes_no, do: "Enter Y or N: "

  def error, do: "Sorry I didn't recognize that"
end
