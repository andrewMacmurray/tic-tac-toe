# multiple FakIO modules to handle different outputs for same "gets" message
defmodule FakeIO do
  def puts(message),             do: message
  def gets("Enter 1, 2 or 3: "), do: "3\n"
  def gets("Enter X or O: "),    do: "X\n"
  def gets("Enter Y or N: "),    do: "y\n"
end

defmodule FakeIO2 do
  def puts(message),             do: message
  def gets("Enter 1, 2 or 3: "), do: "1\n"
  def gets("Enter X or O: "),    do: "O\n"
end

defmodule FakeIO3 do
  def puts(message), do: message
  def gets("> "),    do: "5\n"
end
