defmodule TicTacToe.Console.Message do
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

  def tile_symbol(:human_v_computer), do: "Ok, which tile Symbol would you like?"
  def tile_symbol(:human_v_human),    do: "Ok Player 1, which tile Symbol would you like?"

  def enter_tile_symbol, do: "Enter X or O: "

  def player, do: "Would you like to go first?"

  def yes_no, do: "Enter Y or N: "

  def error,  do: "Sorry I didn't recognize that"

  def computer_move({n, _}), do: "Ok, I'll take tile #{n}"

  def user_move({n, _}, :player_1), do: "Player 1 took tile #{n}"
  def user_move({n, _}, :player_2), do: "Player 2 took tile #{n}"

  def next_move(:player_1), do: "Your turn Player 1"
  def next_move(:player_2), do: "Your turn Player 2"
  def next_move,            do: "Your turn"
end
