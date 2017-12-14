defmodule TicTacToe.Minimax do
  @moduledoc false
  alias TicTacToe.Board

  # the minimax algorithm follows each move to a terminal state
  # assigns moves a positive or negative score depending on player perspective
  # free codecamp article: https://goo.gl/Zd8eJh
  def best_move(board, ai_player) do
    alpha_beta    = {-100, 100}
    player_state  = {ai_player, false}
    initial_depth = 1
    minimax(board, initial_depth, player_state, alpha_beta)
  end

  def minimax(board, depth, {player, is_oponent} = ps, alpha_beta) do
    win = Board.winner?(board, player)
    cond do
      win && !is_oponent ->  1 / depth
      win &&  is_oponent -> -1 / depth
      Board.full?(board) ->  0
      true               -> go_again(board, depth + 1, swap_player_state(ps), alpha_beta)
    end
  end

  def go_again(board, depth, ps, alpha_beta) do
    board
    |> Board.possible_moves()
    |> Enum.reduce_while(alpha_beta, fn(mv, ab) -> ab_prune(mv, board, depth, ps, ab) end)
  end

  def ab_prune(mv, board, depth, {player, is_oponent} = ps, {a, b} = ab) do
    next_board = Board.update(board, mv, player)
    val        = minimax(next_board, depth, ps, ab)
    if !is_oponent do
      Enum.min([b, val]) |> handle_halt(is_oponent, ab, mv)
    else
      Enum.max([a, val]) |> handle_halt(is_oponent, ab, mv)
    end
  end

  def handle_halt(new_b, false, {a, _}, mv) do
    if a >= new_b do
      {:halt, mv}
    else
      {:cont, {a, new_b}}
    end
  end

  def handle_halt(new_a, true, {_, b}, mv) do
    if new_a >= b do
      {:halt, mv}
    else
      {:cont, {new_a, b}}
    end
  end

  def swap_player_state({player, is_oponent}) do
    {Board.swap_player(player), !is_oponent}
  end
end
