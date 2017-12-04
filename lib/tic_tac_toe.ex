defmodule TicTacToe do
  @moduledoc """
  Tic Tac Toe Game
  """
  alias TicTacToe.{Board, AI}
  alias TicTacToe.Console.{RenderBoard, Options}
  alias IO.ANSI

  def run(io \\ IO) do
    Options.get(io)
    |> init(io)
    |> handle(io)
  end

  def handle({b, g, p} = state, io \\ IO) do
    board = Board.update(b, g, p)
    case Board.game_status(board) do
      :non_terminal -> next(state, io) |> handle(io)
      _             -> final(:human_v_human, board) |> io.puts()
    end
  end

  def final(:human_v_human, board) do
    [ clear_screen(),
      RenderBoard.render_final(:human_v_human, board)
    ]
    |> Enum.join("\n")
  end

  def next({board, guess, player}, io \\ IO) do
    clear_screen() |> io.puts()
    next_board = Board.update(board, guess, player)
    show_state = RenderBoard.render_change(:human_v_human, next_board, guess, player)
    io.puts(show_state)

    next_player     = Board.swap_player(player)
    {next_guess, _} = io.gets("> ") |> Integer.parse()
    {next_board, next_guess, next_player}
  end

  def init(:computer_v_computer) do
    board  = %Board{}
    player = :player_1
    {board, AI.run(board, player), player}
  end

  def init({:human_v_human, symbol, player}, io \\ IO) do
    clear_screen() |> io.puts()
    board = init_board(symbol, player)
    RenderBoard.init_message(:human_v_human, board, player) |> io.puts()

    {first_guess, _} = io.gets("> ") |> Integer.parse()
    {board, first_guess, player}
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
