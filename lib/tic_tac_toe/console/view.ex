defmodule TicTacToe.Console.View do
  @moduledoc false
  alias TicTacToe.Board
  alias TicTacToe.Util.Message
  alias IO.ANSI

  @doc """
  Renders the final state of a game to a string
  """
  def render_terminus(model) do
    case model.game_type do
      :human_v_computer -> human_computer_terminus(model)
      _                 -> standard_terminus(model)
    end
  end

  defp standard_terminus(model) do
    [ render_board(model.board),
      standard_terminus_message(model.game_status)
    ]
    |> Message.join_lines()
  end

  def human_computer_terminus(model) do
    [ render_board(model.board),
      ai_terminus_message(model.game_status)
    ]
    |> Message.join_lines()
  end

  defp standard_terminus_message(game_status) do
    case game_status do
      :draw  -> Message.draw()
      player -> Message.player_win(player)
    end
  end

  defp ai_terminus_message(game_status) do
    case game_status do
      :draw -> Message.draw()
      _     -> Message.computer_win() # User should never win
    end
  end

  @doc """
  Renders a change in state made by a move to a string
  """
  def render_change(guess, prev_model, curr_model) do
    [ render_board(curr_model.board),
      move_summary(guess, prev_model)
    ]
    |> Message.join_lines()
  end

  @doc """
  Renders a message for an invalid guess as a string
  """
  def render_invalid(model) do
    [ render_board(model.board),
      Message.invalid_guess(model.game_type, model.next_player),
      Message.guess_instructions()
    ]
    |> Message.join_lines()
  end

  @doc """
  Renders a messsage for an unrecognized guess as a string
  """
  def render_unrecognized(model) do
    [ render_board(model.board),
      Message.unrecognized_guess(model.game_type, model.next_player),
      Message.move_instructions()
    ]
    |> Message.join_lines()
  end

  @doc """
  Renders a summary of the move made as a string
  """
  def move_summary(guess, model) do
    case model.game_type do
      :human_v_computer -> human_computer_summary(guess, model)
      _                 -> standard_summary(guess, model)
    end
  end

  defp standard_summary(guess, model) do
    next_player = Board.swap_player(model.next_player)
    [
      Message.user_move(guess, model.next_player),
      Message.next_move(next_player)
    ]
    |> Message.join_lines()
  end

  defp human_computer_summary(guess, model) do
    if model.next_player == model.ai_player do
      [ Message.computer_guess(guess),
        Message.next_move_human()
      ]
    else
      [ Message.human_guess(guess),
        Message.next_move_computer()
      ]
    end
    |> Message.join_lines()
  end

  @doc """
  Renders the initial state of a game as a string
  """
  def render_init(model) do
    case model.game_type do
      :human_v_computer -> human_computer_init(model)
      _                 -> standard_init(model)
    end
  end

  defp human_computer_init(model) do
    if   model.next_player == model.ai_player do ""
    else standard_init(model)
    end
  end

  defp standard_init(model) do
    [ render_board(model.board),
      next_move_message(model.game_type, model.next_player)
    ]
    |> Message.join_lines()
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
    |> Message.join_lines()
    |> pad_board()
  end

  defp pad_board(board) do
    [
      board_outer_divider(),
      board,
      board_outer_divider()
    ]
    |> Message.join_lines()
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
      {_, :X}     -> bright_green("X")
      {_, :O}     -> bright_blue("O")
      {n, :empty} -> "#{n}"
    end
  end

  defp bright_green(str), do: ANSI.format([:bright, :green, str])
  defp bright_blue(str),  do: ANSI.format([:bright, :blue, str])
end
