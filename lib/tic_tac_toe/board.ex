defmodule TicTacToe.Board do
  @moduledoc false
  alias TicTacToe.Board

  defstruct [
    :player_1,
    :player_2,
    :tiles,
    :scale
  ]

  @doc """
  Inits a board with given scale and player tiles
  """
  def init(scale, p1 \\ :X, p2 \\ :O) do
    %Board{
      player_1: p1,
      player_2: p2,
      tiles:    empty_board(scale),
      scale:    scale
    }
  end

  defp empty_board(scale) do
    1..(scale * scale) |> Map.new(fn move -> {move, :empty} end)
  end

  @doc """
  Updates a board with a move for a given player
  """
  def update(board, move, player) do
    %{board | tiles: update_tiles(board, move, player)}
  end

  defp update_tiles(board, move, player) do
    %{board.tiles | move => Board.tile_symbol(board, player)}
  end

  @doc """
  Returns true if tile at position is empty
  """
  def empty_at?(board, move) do
    tile = board.tiles[move]
    tile == :empty
  end

  @doc """
  Returns a list of possible moves
  """
  def possible_moves(board), do: moves_(board.tiles, :empty)

  @doc """
  Returns a list of moves made by a given player
  """
  def moves(board, :player_1), do: moves_(board.tiles, board.player_1)
  def moves(board, :player_2), do: moves_(board.tiles, board.player_2)

  defp moves_(tiles, tile_type) do
    tiles
    |> Map.to_list()
    |> Enum.filter(fn {_, tile} -> tile == tile_type end)
    |> Enum.map(fn {move, _} -> move end)
  end

  @doc """
  Returns true if the given player has won
  """
  def winner?(board, player) do
    mvs = moves(board, player)
    winning_states(board.scale)
    |> Enum.map(fn win_state -> match_winning_moves(win_state, mvs) end)
    |> Enum.any?(fn xs -> length(xs) == board.scale end)
  end

  def match_winning_moves(win_state, moves) do
    moves |> Enum.filter(fn x -> Enum.member?(win_state, x) end)
  end

  @doc """
  Returns the status of the game
  """
  def status(board) do
    cond do
      winner?(board, :player_1) -> :player_1_win
      winner?(board, :player_2) -> :player_2_win
      full?(board)              -> :draw
      true                      -> :non_terminal
    end
  end

  @doc """
  Returns true if all the board tiles have been taken
  """
  def full?(board) do
    mvs = possible_moves(board) |> length()
    mvs == 0
  end

  @doc """
  Gets tile symbol for given player
  """
  def tile_symbol(board, player) do
    case player do
      :player_1 -> board.player_1
      :player_2 -> board.player_2
    end
  end

  @doc """
  Swaps player for alternate one
  """
  def swap_player(:player_1), do: :player_2
  def swap_player(:player_2), do: :player_1

  @doc """
  Swaps tile symbol for alternate one
  """
  def swap_symbol(:X), do: :O
  def swap_symbol(:O), do: :X

  @doc """
  Returns all possible winning states for a given size of board
  """
  def winning_states(n) do
    rows(n) ++ columns(n)
            ++ [left_diag(n)]
            ++ [right_diag(n)]
  end

  defp rows(n),       do: 1..(n * n)     |> Enum.chunk(n)
  defp columns(n),    do: 1..n           |> Enum.map(fn x -> col n, x end)
  defp col(n, y),     do: 0..(n - 1)     |> Enum.map(fn x -> x * n + y end)
  defp left_diag(n),  do: 1..n           |> Enum.scan(fn _, x -> x + n + 1 end)
  defp right_diag(n), do: n..(n + n - 1) |> Enum.scan(fn _, x -> x + n - 1 end)
end
