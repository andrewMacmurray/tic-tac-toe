defmodule BoardTestHelper do
  alias TicTacToe.{Board, AI}

  # takes a list of {move, player} and applies them in sequence to a board
  def batch_update(moves, board) do
    Enum.reduce moves, board, fn({mv, player}, acc) ->
      Board.update(acc, mv, player)
    end
  end

  # takes a list of moves and applies them to a board alternating player each turn
  def run_alternating_players([], _, board), do: board
  def run_alternating_players([mv | moves], player, board) do
    new_b = Board.update(board, mv, player)
    run_alternating_players(moves, Board.swap_player(player), new_b)
  end


  # takes all board states ([[state]]) and adds a player to each
  # returns [[{move, player}]]
  def add_player_to_states(states, player) do
    states |> Enum.map(fn xs -> Enum.map(xs, fn x -> {x, player} end) end)
  end

  # the "user" plays a random move against the AI until a terminal state has been reached
  def play_to_the_death(board, ai_player) do
    if terminal?(board) do
      board
    else
      mvs         = Board.possible_moves(board)
      random_move = Enum.random(mvs)
      new_b       = board |> Board.update(random_move, Board.swap_player(ai_player))
      if terminal?(new_b) do
        new_b
      else
        best_move = AI.run(new_b, ai_player)
        new_b
        |> Board.update(best_move,ai_player)
        |> play_to_the_death(ai_player)
      end
    end
  end

  def terminal?(board) do
    p1_win = Board.winner?(board, :player_1)
    p2_win = Board.winner?(board, :player_2)
    full   = Board.full?(board)
    p1_win || p2_win || full
  end
end
