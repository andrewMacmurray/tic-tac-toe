defmodule TicTacToe.UI.Console do
  @moduledoc false
  alias TicTacToe.UI.Message

  def greet(io \\ IO) do
    [
      Message.welcome(),
      Message.divider(),
      Message.game_types() |> join_lines(),
      Message.enter_option()
    ]
    |> join_lines()
    |> io.puts()
  end

  defp join_lines(messages), do: Enum.join(messages, "\n")

  def get_user_option(io \\ IO), do: io.gets("> ") |> parse_option()

  def parse_option(input) do
    case String.trim(input) do
      "1" -> :human_v_human
      "2" -> :computer_v_computer
      "3" -> :human_v_computer
      _   -> :error
    end
  end
end
