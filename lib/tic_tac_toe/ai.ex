defmodule TicTacToe.AI do
  @moduledoc false
  alias TicTacToe.{Board, Minimax}

  @doc """
  Returns the best possible move for a given player
  """
  def run(board, ai_player) do
    case board.scale do
      3 -> scale_three_strategy(board, ai_player)
      4 -> scale_four_strategy(board, ai_player)
    end
  end

  def scale_four_strategy(board, ai_player) do
    moves_left = Board.possible_moves(board) |> length()
    cond do
      moves_left == 16 -> 6
      moves_left == 15 -> take_center_four(board)
      moves_left > 8   -> aggressively_block(board, ai_player)
      true             -> Minimax.best_move(board, ai_player)
    end
  end

  def take_center_four(board) do
    [6, 7, 10, 11] |> Enum.find(fn tile -> Board.empty_at?(board, tile) end)
  end

  def aggressively_block(board, ai_player) do
    counter_dangerous = block_dangerous_move(board, ai_player)
    counter_promising = block_promising_move(board, ai_player)
    additional_move   = add_to_existing_move(board, ai_player)
    cond do
      counter_dangerous != :no_move -> counter_dangerous
      counter_promising != :no_move -> counter_promising
      true                          -> additional_move
    end
  end

  def add_to_existing_move(board, ai_player) do
    case find_best_existing_move(board, ai_player) do
      :no_move -> :no_move
      {st, mv} ->
        st
        |> Enum.filter(fn x -> not Enum.member?(mv, x) end)
        |> List.first()
    end
  end

  def find_best_existing_move(board, ai_player) do
    moves = Board.moves(board, ai_player)
    res =
      Board.winning_states(4)
      |> Enum.map(fn st -> {st, Board.match_winning_moves(st, moves)} end)
      |> Enum.filter(fn {st, _} -> existing_move_conditions(st, board, ai_player) end)
    case res do
      [] -> :no_move
      xs -> xs |> Enum.max_by(fn {_, mv} -> length(mv) end)
    end
  end

  def existing_move_conditions(st, board, ai_player) do
    oponent = Board.swap_player(ai_player)
    not moves_taken?(st, board, oponent)
  end

  def block_dangerous_move(board, ai_player) do
    case find_dangerous_oponent_move(board, ai_player) do
      :no_move -> :no_move
      %{win_state: st, move: mv} ->
        st
        |> Enum.filter(fn x -> not Enum.member?(mv, x) end)
        |> List.first()
    end
  end

  def find_dangerous_oponent_move(board, ai_player) do
    oponent = Board.swap_player(ai_player)
    moves   = Board.moves(board, oponent)
    res =
      Board.winning_states(4)
      |> Enum.map(fn st -> {st, Board.match_winning_moves(st, moves)} end)
      |> Enum.find(fn {st, mvs} -> dangerous_move_conditions(st, mvs, board, ai_player) end)
    case res do
      nil       -> :no_move
      {st, mvs} -> %{win_state: st, move: mvs}
    end
  end

  def dangerous_move_conditions(st, mvs, board, ai_player) do
    length(mvs) == 3 and (not moves_taken?(st, board, ai_player))
  end

  def block_promising_move(board, ai_player) do
    case find_promising_oponent_move(board, ai_player) do
      :no_move -> :no_move
      %{win_state: st, move: mv} ->
        st
        |> Enum.filter(fn x -> not Enum.member?(mv, x) end)
        |> List.first()
    end
  end

  def find_promising_oponent_move(board, ai_player) do
    oponent    = Board.swap_player(ai_player)
    moves      = Board.moves(board, oponent)
    res =
      Board.winning_states(4)
      |> Enum.map(fn st -> {st, Board.match_winning_moves(st, moves)} end)
      |> Enum.find(fn {st, mvs} -> promising_move_conitions(st, mvs, board, ai_player) end)
    case res do
      nil       -> :no_move
      {st, mvs} -> %{win_state: st, move: mvs}
    end
  end

  def promising_move_conitions(st, mvs, board, ai_player) do
    length(mvs) > 1 and (not moves_taken?(st, board, ai_player))
  end

  def moves_taken?(win_state, board, ai_player) do
    win_state
    |> Enum.map(fn move -> board.tiles[move] end)
    |> Enum.any?(fn x -> x == tile_type(board, ai_player) end)
  end

  def tile_type(board, player) do
    case player do
      :player_1 -> board.player_1
      :player_2 -> board.player_2
    end
  end

  def scale_three_strategy(board, ai_player) do
    moves_left = Board.possible_moves(board) |> length()
    case moves_left do
      9 -> 5
      8 -> counter_first_move_three(board)
      _ -> Minimax.best_move(board, ai_player)
    end
  end

  defp counter_first_move_three(board) do
    if Board.empty_at?(board, 5) do 5 else 1 end
  end
end
