defmodule TicTacToe.Board do
  @moduledoc false
  @empty_board 1..9 |> Map.new(fn move -> {move, :empty} end)

  defstruct [
    player_1: :X,
    player_2: :O,
    tiles: @empty_board
  ]

  @doc """
  Updates a board with a move for a given player
  """
  def update(board, move, player) do
    %{board | tiles: update_tiles(board, move, player)}
  end

  defp update_tiles(board, move, player) do
    case player do
      :player_1 -> %{board.tiles | move => board.player_1}
      :player_2 -> %{board.tiles | move => board.player_2}
    end
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
    winning_states()
    |> Enum.map(fn win_state -> match_winning_moves(win_state, mvs) end)
    |> Enum.any?(fn xs -> length(xs) == 3 end)
  end

  defp match_winning_moves(win_state, moves) do
    moves |> Enum.filter(fn x -> Enum.member?(win_state, x) end)
  end

  defp winning_states do
    [
      [1, 2, 3], [4, 5, 6], [7, 8, 9],
      [1, 4, 7], [2, 5, 8], [3, 6, 9],
      [1, 5, 9], [3, 5, 7]
    ]
  end

  @doc """
  Returns true if all the board tiles have been taken
  """
  def full?(board) do
    mvs = possible_moves(board) |> length()
    mvs == 0
  end

  @doc """
  Swaps player for the alternate one
  """
  def swap_player(:player_1), do: :player_2
  def swap_player(:player_2), do: :player_1


  @doc """
  Returns the player who made a given move
  """
  def player_from_move({_, tile}, board) do
    if tile == board.player_1 do
      :player_1
    else
      :player_2
    end
  end
end
