defmodule TicTacToe.Minimax do
  @moduledoc false
  alias TicTacToe.Board

  # the minimax algorithm follows each move to a terminal state
  # assigns moves a positive or negative score depending on player perspective
  # free codecamp article: https://goo.gl/Zd8eJh
  def best_move(board, ai_player) do
    {mv, _} =
      board
      |> Board.possible_moves()
      |> Enum.map(fn mv -> get_move_score(mv, board, ai_player) end)
      |> Enum.max_by(fn {_, {_, b}} -> b end)
    mv
  end

  def get_move_score(move, board, ai_player) do
    alpha_beta    = {-100, 100}
    player_state  = {ai_player, false}
    initial_depth = 1
    board         = Board.update(board, move, ai_player)
    {move, minimax(board, initial_depth, player_state, alpha_beta)}
  end

  def minimax(board, depth, {player, is_oponent} = ps, {a, b} = alpha_beta) do
    win = Board.winner?(board, player)
    cond do
      win && !is_oponent -> {1 / depth, b}
      win &&  is_oponent -> {a, -1 / depth}
      Board.full?(board) -> {a, b}
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
    {a_, b_}   = minimax(next_board, depth, ps, ab)
    if !is_oponent do
      max(a_, a) |> handle_halt(is_oponent, ab)
    else
      min(b_, b) |> handle_halt(is_oponent, ab)
    end
  end

  def handle_halt(new_a, false, {_, b}) do
    if new_a >= b do
      {:halt, {new_a, b}}
    else
      {:cont, {new_a, b}}
    end
  end

  def handle_halt(new_b, true, {a, _}) do
    if a >= new_b do
      {:halt, {a, new_b}}
    else
      {:cont, {a, new_b}}
    end
  end

  def swap_player_state({player, is_oponent}) do
    {Board.swap_player(player), !is_oponent}
  end
end
