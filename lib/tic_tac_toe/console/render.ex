defmodule TicTacToe.Console.Render do
  @moduledoc false
  alias TicTacToe.Board
  alias TicTacToe.Console.Message

  def render_final(:human_v_human, board) do
    [ render_board(board),
      final_message(board)
    ]
    |> Enum.join("\n")
  end

  def render_final(:computer_v_computer, board) do
    [ render_board(board),
      final_message(board)
    ]
    |> Enum.join("\n")
  end

  def render_final(:human_v_computer, board, ai_player) do
    [ render_board(board),
      final_message(board, ai_player)
    ]
    |> Enum.join("\n")
  end

  defp final_message(board, ai_player) do
    case Board.status(board) do
      :non_terminal -> :error
      :draw         -> Message.draw()
      :player_1_win -> final_message_(:player_1, ai_player)
      :player_2_win -> final_message_(:player_2, ai_player)
    end
  end

  defp final_message(board) do
    case Board.status(board) do
      :non_terminal -> :error
      :draw         -> Message.draw()
      player        -> Message.player_win(player)
    end
  end

  def final_message_(_player, _ai_player) do
    # User should never win
    Message.computer_win()
  end

  def render_change(:human_v_computer, board, guess, player, ai_player) do
    [ render_board(board),
      move_summary(:human_v_computer, guess, player, ai_player)
    ]
    |> Enum.join("\n")
  end

  def render_change(:computer_v_computer, board, guess, player) do
    [ render_board(board),
      move_summary(:computer_v_computer, guess, player)
    ]
    |> Enum.join("\n")
  end

  def render_change(:human_v_human, board, guess, player) do
    [ render_board(board),
      move_summary(:human_v_human, guess, player)
    ]
    |> Enum.join("\n")
  end

  def render_invalid(game_type, board, player) do
    [ render_board(board),
      Message.invalid_guess(game_type, player),
      Message.guess_instructions()
    ]
    |> Enum.join("\n")
  end

  def render_unrecognized(game_type, board, player) do
    [ render_board(board),
      Message.unrecognized_guess(game_type, player),
      Message.move_instructions()
    ]
    |> Enum.join("\n")
  end

  def move_summary(:human_v_computer, guess, player, ai_player) do
    if player == ai_player do
      [ Message.computer_guess(guess),
        Message.next_move_human()
      ]
    else
      [ Message.human_guess(guess),
        Message.next_move_computer()
      ]
    end
    |> Enum.join("\n")
  end

  def move_summary(:human_v_human, guess, player), do: same_type_summary(guess, player)
  def move_summary(:computer_v_computer, guess, player), do: same_type_summary(guess, player)

  defp same_type_summary(guess, player) do
    player_move_message = Message.user_move(guess, player)
    next_player_message = player |> Board.swap_player() |> Message.next_move()
    [
      player_move_message,
      next_player_message
    ]
    |> Enum.join("\n")
  end

  def init_message(:human_v_computer, board, player) do
    case player do
      :player_1 -> init_message_(:human_v_computer, board, player)
      :player_2 -> ""
    end
  end

  def init_message(game_type, board, player) do
    init_message_(game_type, board, player)
  end

  defp init_message_(game_type, board, player) do
    [ render_board(board),
      next_move_message(game_type, player)
    ]
    |> Enum.join("\n")
  end

  defp next_move_message(game_type, player) do
    case game_type do
      :human_v_computer -> Message.next_move_human()
      _                 -> Message.next_move(player)
    end
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
