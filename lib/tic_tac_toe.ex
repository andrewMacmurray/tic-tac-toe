defmodule TicTacToe do
  @moduledoc """
  Tic Tac Toe Game
  """
  alias TicTacToe.{Board, AI}
  alias TicTacToe.Console.{Render, Options}
  alias IO.ANSI

  def run(io \\ IO) do
    Options.get(io)
    |> init(io)
    |> handle(io)
  end

  def handle(state, io \\ IO)
  def handle({:human_v_computer, {b, g, p}, ai_player}, io) do
    next_board = Board.update(b, g, p)
    case Board.status(next_board) do
      :non_terminal -> next(:human_v_computer, {b, g, p}, ai_player, io) |> handle(io)
      _             -> final(:human_v_computer, next_board, ai_player) |> io.puts()
    end
  end

  def handle({game_type, {b, g, p} = current_state}, io) do
    next_board = Board.update(b, g, p)
    case Board.status(next_board) do
      :non_terminal -> next(game_type, current_state, io) |> handle(io)
      _             -> final(game_type, next_board) |> io.puts()
    end
  end

  def final(:human_v_human, board) do
    [ clear_screen(),
      Render.render_final(:human_v_human, board)
    ]
    |> Enum.join("\n")
  end

  def final(:computer_v_computer, board) do
    [ clear_screen(),
      Render.render_final(:computer_v_computer, board)
    ]
    |> Enum.join("\n")
  end

  def final(:human_v_computer, board, ai_player) do
    [ clear_screen(),
      Render.render_final(:human_v_computer, board, ai_player)
    ]
    |> Enum.join("\n")
  end

  def next(game_type, state, io \\ IO)
  def next(:human_v_human, {board, guess, player}, io) do
    clear_screen() |> io.puts()
    next_board = Board.update(board, guess, player)
    show_state = Render.render_change(:human_v_human, next_board, guess, player)
    io.puts(show_state)

    next_player     = Board.swap_player(player)
    {next_guess, _} = io.gets("> ") |> Integer.parse()
    {:human_v_human, {next_board, next_guess, next_player}}
  end

  def next(:computer_v_computer, {board, guess, player}, io) do
    clear_screen() |> io.puts()
    next_board = Board.update(board, guess, player)
    show_state = Render.render_change(:computer_v_computer, next_board, guess, player)
    io.puts(show_state)

    next_player = Board.swap_player(player)
    next_guess  = AI.run(next_board, next_player)
    {:computer_v_computer, {next_board, next_guess, next_player}}
  end

  def next(:human_v_computer, {board, guess, player}, ai_player, io) do
    clear_screen() |> io.puts()
    next_board = Board.update(board, guess, player)
    Render.render_change(:human_v_computer, next_board, guess, player, ai_player) |> io.puts()
    if player != ai_player do
      next_guess  = AI.run(next_board, ai_player)
      {:human_v_computer, {next_board, next_guess, ai_player}, ai_player}
    else
      {next_guess, _} = io.gets("> ") |> Integer.parse()
      next_player = Board.swap_player(player)
      {:human_v_computer, {next_board, next_guess, next_player}, ai_player}
    end
  end

  def init(state, io \\ IO)
  def init(:computer_v_computer, _) do
    board  = %Board{}
    player = :player_1
    {:computer_v_computer, {board, AI.run(board, player), player}}
  end
  def init({:human_v_human, symbol, player}, io),    do: init_human_v_human(symbol, player, io)
  def init({:human_v_computer, symbol, player}, io), do: init_human_v_computer(symbol, player, io)

  def init_human_v_computer(symbol, player, io \\ IO) do
    clear_screen() |> io.puts()
    board = init_board(symbol, player)
    case player do
      :player_1 ->
        Render.init_message(:human_v_computer, board, player) |> io.puts()
        {first_guess, _} = io.gets("> ") |> Integer.parse()
        {:human_v_computer, {board, first_guess, player}, :player_2}
      :player_2 ->
        {:human_v_computer, {board, AI.run(board, :player_1), :player_1}, :player_1}
    end
  end

  def init_human_v_human(symbol, player, io \\ IO) do
    clear_screen() |> io.puts()
    board = init_board(symbol, player)
    Render.init_message(:human_v_human, board, player) |> io.puts()

    {first_guess, _} = io.gets("> ") |> Integer.parse()
    {:human_v_human, {board, first_guess, player}}
  end

  defp init_board(symbol, player) do
    alternate = Board.swap_symbol(symbol)
    case player do
      :player_1 -> %Board{player_1: symbol, player_2: alternate}
      :player_2 -> %Board{player_2: symbol, player_1: alternate}
    end
  end

  defp clear_screen, do: ANSI.format([:clear, :home])
end
