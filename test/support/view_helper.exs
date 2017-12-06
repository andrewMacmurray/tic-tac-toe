defmodule ViewTestHelper do
  @moduledoc false
  alias IO.ANSI

  @doc """
  Removes any ANSI sequences from a string
  """
  def strip_ansi(msg) do
    [
      ANSI.blue(),
      ANSI.green(),
      ANSI.bright(),
      "\e[0m"
    ]
    |> Enum.reduce(to_string(msg), fn(x, acc) -> String.replace(acc, x, "") end)
  end
end
