# multiple FakIO modules to handle different outputs for same "gets" message
defmodule FakeIO do
  def puts(message), do: message
end

defmodule OptionIO1 do
  def puts(message),             do: message
  def gets("Enter 1, 2 or 3: "), do: "1\n"
  def gets("Enter 3 or 4: "),    do: "3\n"
end

defmodule OptionIO2 do
  def puts(message),             do: message
  def gets("Enter 1, 2 or 3: "), do: "2\n"
  def gets("Enter Y or N: "),    do: "n\n"
  def gets("Enter 3 or 4: "),    do: "3\n"
end

defmodule OptionIO3 do
  def puts(message),             do: message
  def gets("Enter 1, 2 or 3: "), do: "3\n"
  def gets("Enter X or O: "),    do: "X\n"
  def gets("Enter Y or N: "),    do: "y\n"
  def gets("Enter 3 or 4: "),    do: "3\n"
end

defmodule OptionIOYes do
  def puts(message), do: message
  def gets("Enter Y or N: "), do: "y\n"
end

defmodule OptionIONo do
  def puts(message), do: message
  def gets("Enter Y or N: "), do: "n\n"
end

defmodule IOGuess5 do
  def puts(message), do: message
  def gets("> "),    do: "5\n"
end

defmodule IOGuess9 do
  def puts(message), do: message
  def gets("> "),    do: "9\n"
end

defmodule IOGuessUnrecognized do
  def puts(message), do: message
  def gets("> "),    do: "hello?\n"
end

defmodule FakeProcess do
  def sleep(_), do: :ok
end
