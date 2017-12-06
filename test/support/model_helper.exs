defmodule ModelTestHelper do
  alias TicTacToe.Console.Model

  def sequence(initial_model, guesses) do
    Enum.reduce guesses, initial_model, fn(x, acc) ->
      Model.update(acc, x)
    end
  end
end
