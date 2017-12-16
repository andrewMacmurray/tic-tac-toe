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
    if model.next_player == model.ai_player do
      [ render_board(model.board),
        Message.first_move_computer()
      ]
      |> Message.join_lines()
    else
      standard_init(model)
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

  @doc """
  Renders initial greeting for user
  """
  def render_greeting do
    [
      Message.welcome(),
      Message.divider()
    ]
    |> Message.join_lines()
  end

  def render_board(board) do
    board.tiles
    |> Enum.to_list()
    |> Enum.chunk(board.scale)
    |> Enum.map(&render_row/1)
    |> Enum.intersperse(board_inner_divider(board.scale))
    |> Message.join_lines()
    |> pad_board(board.scale)
  end

  defp pad_board(board_string, scale) do
    [
      board_outer_divider(scale),
      board_string,
      board_outer_divider(scale)
    ]
    |> Message.join_lines()
  end

  defp board_outer_divider(scale) do
       String.duplicate("---", scale + 1)
    <> String.duplicate("-", scale)
  end

  defp board_inner_divider(scale) do
    1..(scale + 1)
    |> Enum.map(fn _ -> "---" end)
    |> Enum.intersperse("+")
    |> Enum.join("")
  end

  def render_row(row) do
    row
    |> Enum.map(&render_tile/1)
    |> Enum.flat_map(fn x -> [x, tile_spacing(x)] end)
    |> drop_last()
    |> Enum.map(&color_tile/1)
    |> Enum.join("")
    |> pad_row()
  end

  def drop_last(xs) do
    {_, xs} = xs |> List.pop_at(-1)
    xs
  end

  defp pad_row(row), do: "   " <> row

  def tile_spacing(tile_string) do
    case String.length(tile_string) do
      1 -> "   "
      2 -> "  "
      _ -> " "
    end
  end

  def color_tile(tile_string) do
    case tile_string do
      "X" -> bright_green("X")
      "O" -> bright_blue("O")
      t   -> t
    end
  end

  def render_tile(tile) do
    case tile do
      {_, :X}     -> "X"
      {_, :O}     -> "O"
      {n, :empty} -> "#{n}"
    end
  end

  defp bright_green(str), do: ANSI.format([:bright, :green, str])
  defp bright_blue(str),  do: ANSI.format([:bright, :blue, str])
end
