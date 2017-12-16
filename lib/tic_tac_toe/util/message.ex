defmodule TicTacToe.Util.Message do
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
    |> join_lines()
  end

  def enter_game_option, do: "Enter 1, 2 or 3: "

  def board_scale, do: "What size of board would you like to play on?"
  def three_or_four, do: "Enter 3 or 4: "

  def tile_symbol(:human_v_computer), do: "Ok, which tile Symbol would you like?"
  def tile_symbol(:human_v_human),    do: "Ok Player 1, which tile Symbol would you like?"

  def enter_tile_symbol, do: "Enter X or O: "

  def player, do: "Would you like to go first?"

  def yes_no, do: "Enter Y or N: "

  def error,  do: "Sorry I didn't recognize that"

  def computer_guess(n), do: "Ok, I'll take tile #{n}"
  def human_guess(n),    do: "You took tile #{n}"

  def user_move(n, :player_1), do: "Player 1 took tile #{n}"
  def user_move(n, :player_2), do: "Player 2 took tile #{n}"

  def unrecognized_guess(:human_v_human, :player_1), do: "Player 1, number not recognized"
  def unrecognized_guess(:human_v_human, :player_2), do: "Player 2, number not recognized"
  def unrecognized_guess(:human_v_computer, _),      do: "Number not recognized"
  def move_instructions,                             do: "Please enter a number 1-9"

  def invalid_guess(:human_v_human, :player_1), do: "Player 1, that tile has already been taken"
  def invalid_guess(:human_v_human, :player_2), do: "Player 2, that tile has already been taken"
  def invalid_guess(:human_v_computer, _),      do: "That tile has already been taken"
  def guess_instructions,       do: "Please enter a valid guess"

  def first_move_computer,  do: "I'll go first, let me think..."
  def next_move(:player_1), do: "Your turn Player 1"
  def next_move(:player_2), do: "Your turn Player 2"
  def next_move_human,      do: "Your turn"
  def next_move_computer,   do: "Ok, I'll go next"

  def player_win(:player_1_win), do: "Player 1 won! 🎉"
  def player_win(:player_2_win), do: "Player 2 won! 🎉"
  def draw,         do: "It's a draw!"
  def user_win,     do: "You won! 🎉"
  def computer_win, do: "You lost! 😢"

  def play_again, do: "Do you want to play another game?"
  def goodbye,    do: "Ok bye! 👋"

  @doc """
  Joins a list of strings together with a new line
  """
  def join_lines(xs), do: Enum.join(xs, "\n")
end
