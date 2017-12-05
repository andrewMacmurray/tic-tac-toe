defmodule TicTacToe.Model do
  @moduledoc false
  defstruct [
    :game_type,
    :board,
    :ai_player,
    next_player: :player_1,
    game_status: :non_terminal
  ]

  alias TicTacToe.{Model, Board}

  @doc """
  Initialises a game for a given config
  """
  def init({:human_v_human, symbol, player}) do
    %Model{
      game_type: :human_v_human,
      board:     init_board(symbol, player)
    }
  end

  def init({:human_v_computer, symbol, player}) do
    %Model{
      game_type: :human_v_computer,
      board:     init_board(symbol, player),
      ai_player: Board.swap_player(player)
    }
  end

  def init(:computer_v_computer) do
    %Model{
      game_type: :computer_v_computer,
      board:     %Board{}
    }
  end

  defp init_board(symbol, player) do
    alternate = Board.swap_symbol(symbol)
    case player do
      :player_1 -> %Board{player_1: symbol, player_2: alternate}
      :player_2 -> %Board{player_2: symbol, player_1: alternate}
    end
  end

  @doc """
  Updates an existing game model with a guess and returns an updated model
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
