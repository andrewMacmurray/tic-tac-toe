defmodule TicTacToe.Console.Options do
  @moduledoc false
  alias TicTacToe.Util.Message

  @doc """
  Prompst user for game options
  """
  def get(io \\ IO) do
    case get_game_option(io) do
      :human_v_computer -> human_v_computer(io)
      opt               -> opt
    end
  end

  def human_v_computer(io \\ IO) do
    tile_message_computer(io)
    tile_symbol = get_tile_symbol(io)
    player      = get_player(io)
    {:human_v_computer, tile_symbol, player}
  end

  defp tile_message_computer(io) do
    :human_v_computer
    |> Message.tile_symbol()
    |> io.puts()
  end

  def get_game_option(io \\ IO) do
    get_game_option_(io)
    |> retry_on_error(&get_game_option/1, io)
  end

  defp get_game_option_(io) do
    show_game_options(io)
    Message.enter_game_option()
    |> io.gets()
    |> parse_game_option()
  end

  def show_game_options(io \\ IO) do
    [
      Message.game_types(),
      Message.divider()
    ]
    |> Message.join_lines()
    |> io.puts()
  end

  def get_tile_symbol(io \\ IO) do
    get_tile_symbol_(io)
    |> retry_on_error(&get_tile_symbol/1, io)
  end

  defp get_tile_symbol_(io) do
    Message.enter_tile_symbol()
    |> io.gets()
    |> parse_tile_symbol()
  end

  def get_player(io \\ IO) do
    get_player_(io)
    |> retry_on_error(&get_player/1, io)
  end

  defp get_player_(io) do
    Message.player() |> io.puts()
    Message.yes_no()
    |> io.gets()
    |> parse_player()
  end

  def retry_on_error(result, func, io \\ IO) do
    case result do
      :error ->
        Message.error() |> io.puts()
        func.(io)
      _ ->
        result
    end
  end

  def parse_game_option(input) do
    case String.trim(input) do
      "1" -> :human_v_human
      "2" -> :computer_v_computer
      "3" -> :human_v_computer
      _   -> :error
    end
  end

  def parse_tile_symbol(input) do
    case format_input(input) do
      "X" -> :X
      "O" -> :O
      "0" -> :O
      _   -> :error
    end
  end

  def parse_player(input) do
    case format_input(input) do
      "Y"   -> :player_1
      "YES" -> :player_1
      "N"   -> :player_2
      "NO"  -> :player_2
      _     -> :error
    end
  end

  defp format_input(input) do
    input
    |> String.trim()
    |> String.upcase()
  end
end
