defmodule TicTacToe.Strategy.FourByFour do
  @moduledoc false
  alias TicTacToe.Strategy.Minimax
  alias TicTacToe.Board

  @doc """
  AI strategy for 4x4 game
  """
  def strategy(board, ai_player) do
    moves_left = Board.possible_moves(board) |> length()
    cond do
      moves_left == 16 -> 6
      moves_left == 15 -> take_center(board)
      moves_left > 8   -> aggressively_block(board, ai_player)
      true             -> Minimax.best_move(board, ai_player)
    end
  end

  @doc """
  Takes a center tile not already taken by a player
  """
  def take_center(board) do
    [6, 7, 10, 11] |> Enum.find(fn tile -> Board.empty_at?(board, tile) end)
  end

  @doc """
  Returns blocking move to oponent's most threatening move
  """
  def aggressively_block(board, ai_player) do
    counter_dangerous = block_dangerous_move(board, ai_player)
    counter_promising = block_promising_move(board, ai_player)
    additional_move   = extend_existing_move(board, ai_player)
    cond do
      counter_dangerous != :no_move -> counter_dangerous
      counter_promising != :no_move -> counter_promising
      true                          -> additional_move
    end
  end

  @doc """
  Returns a move extending the AI's most promising move
  """
  def extend_existing_move(board, ai_player) do
    case find_best_existing_move(board, ai_player) do
      :no_move -> :no_move
      mvs      -> first_matching(mvs)
    end
  end

  def find_best_existing_move(board, ai_player) do
    match_winning_states(board, ai_player)
    |> Enum.filter(fn {st, _} -> unnocupied_win_state?(st, board, ai_player) end)
    |> existing_move_by_length()
  end

  def existing_move_by_length([]), do: :no_move
  def existing_move_by_length(xs), do: Enum.max_by(xs, fn {_, mv} -> length(mv) end)

  def unnocupied_win_state?(st, board, ai_player) do
    oponent = Board.swap_player(ai_player)
    not moves_taken?(st, board, oponent)
  end

  @doc """
  Returns a blocking move to an oponent's most threatening move
  """
  def block_dangerous_move(board, ai_player) do
    case find_dangerous_oponent_move(board, ai_player) do
      :no_move -> :no_move
      mvs      -> first_matching(mvs)
    end
  end

  def find_dangerous_oponent_move(board, ai_player) do
    oponent = Board.swap_player(ai_player)
    match_winning_states(board, oponent)
    |> Enum.find(fn {st, mvs} -> dangerous_move?(st, mvs, board, ai_player) end)
    |> format_move_result()
  end

  def match_winning_states(board, player) do
    moves = board |> Board.moves(player)
    Board.winning_states(4)
    |> Enum.map(fn st -> {st, Board.match_winning_moves(st, moves)} end)
  end

  def dangerous_move?(st, mvs, board, ai_player) do
    length(mvs) == 3 and not moves_taken?(st, board, ai_player)
  end

  @doc """
  Returns a blocking move to an oponent's potential winning move
  """
  def block_promising_move(board, ai_player) do
    case find_promising_oponent_move(board, ai_player) do
      :no_move -> :no_move
      mvs      -> first_matching(mvs)
    end
  end

  def find_promising_oponent_move(board, ai_player) do
    oponent = Board.swap_player(ai_player)
    match_winning_states(board, oponent)
    |> Enum.find(fn {st, mvs} -> promising_oponent_move?(st, mvs, board, ai_player) end)
    |> format_move_result()
  end

  def promising_oponent_move?(st, mvs, board, ai_player) do
    length(mvs) > 1 and not moves_taken?(st, board, ai_player)
  end

  def format_move_result(nil),       do: :no_move
  def format_move_result({st, mv}),  do: %{win_state: st, move: mv}

  def first_matching({st, mv}),                   do: first_matching_(st, mv)
  def first_matching(%{win_state: st, move: mv}), do: first_matching_(st, mv)

  defp first_matching_(st, mv) do
    st
    |> Enum.filter(fn x -> not Enum.member?(mv, x) end)
    |> List.first()
  end

  @doc """
  Checks for a player's presence in a given winning state
  """
  def moves_taken?(win_state, board, ai_player) do
    win_state
    |> Enum.map(fn move -> board.tiles[move] end)
    |> Enum.any?(fn x -> x == Board.tile_symbol(board, ai_player) end)
  end
end
