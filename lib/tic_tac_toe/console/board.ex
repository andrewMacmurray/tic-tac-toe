defmodule TicTacToe.Console.Board do
  @moduledoc false
  alias TicTacToe.Board
  alias TicTacToe.Console.Message

  def move_summary(:human_v_computer, move, _) do
    [
      Message.computer_move(move),
      Message.next_move()
    ]
    |> Enum.join("\n")
  end

  def move_summary(:human_v_human, move, board) do
    player              = Board.player_from_move(move, board)
    player_move_message = Message.user_move(move, player)
    next_move_message   = player |> Board.swap_player() |> Message.next_move()
    [
      player_move_message,
      next_move_message
    ]
    |> Enum.join("\n")
  end

  def render_board(%Board{tiles: tiles}) do
    tiles
    |> Enum.to_list()
    |> Enum.chunk(3)
    |> Enum.map(&render_row/1)
    |> Enum.intersperse(board_inner_divider())
    |> Enum.join("\n")
    |> pad_board()
  end

  defp pad_board(board) do
    [
      board_outer_divider(),
      board,
      board_outer_divider()
    ]
    |> Enum.join("\n")
  end

  defp board_outer_divider, do: "---------------"
  defp board_inner_divider, do: "---+---+---+---"

  def render_row([a, b, c]) do
    [a, b, c]
    |> Enum.map(&render_tile/1)
    |> Enum.intersperse("   ")
    |> Enum.join("")
    |> pad_row()
  end

  defp pad_row(row), do: "   " <> row

  def render_tile(tile) do
    case tile do
      {_, :X}     -> "X"
      {_, :O}     -> "O"
      {n, :empty} -> "#{n}"
    end
  end
end
