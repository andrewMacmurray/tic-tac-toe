defmodule TicTacToe.Console.Model do
  @moduledoc false
  defstruct [
    :game_type,
    :board,
    :ai_player,
    next_player: :player_1,
    game_status: :non_terminal
  ]

  alias TicTacToe.Board
  alias TicTacToe.Console.Model

  @doc """
  Initialises a game for a given config
  """
  def init({:human_v_human, board_scale}) do
    %Model{
      game_type: :human_v_human,
      board:      Board.init(board_scale)
    }
  end

  def init({:human_v_computer, symbol, player, board_scale}) do
    %Model{
      game_type: :human_v_computer,
      board:      assign_board(symbol, player, board_scale),
      ai_player:  Board.swap_player(player)
    }
  end

  def init({:computer_v_computer, board_scale}) do
    %Model{
      game_type: :computer_v_computer,
      board:      Board.init(board_scale)
    }
  end

  defp assign_board(symbol, player, board_scale) do
    alternate = Board.swap_symbol(symbol)
    case player do
      :player_1 -> Board.init(board_scale, symbol, alternate)
      :player_2 -> Board.init(board_scale, alternate, symbol)
    end
  end

  @doc """
  Updates a game model with a guess and returns the new model
  """
  def update(model, guess) do
    %Model{
      board:       board,
      next_player: player
    } = model

    new_board = Board.update(board, guess, player)
    %{ model |
        board:       new_board,
        next_player: Board.swap_player(player),
        game_status: Board.status(new_board)
     }
  end
end
