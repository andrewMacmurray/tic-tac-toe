defmodule FakeIO do
  def puts(message), do: message
  def gets("> "),    do: "1\n"
end

defmodule ConsoleTest do
  use ExUnit.Case
  alias TicTacToe.UI.Console

  test "Console.greet should welcome the user with instructions" do
    result = Console.greet(FakeIO)
    greeting_messages = [
      "Welcome to Tic Tac Toe",
      "----------------------",
      "Select a game to play:",
      "1. Human vs Human        💁  vs 💁",
      "2. Computer vs Computer  🤖  vs 🤖",
      "3. Human vs Computer     💁  vs 🤖",
      "----------------------",
      "Please enter 1, 2 or 3:"
    ]
    for message <- greeting_messages do
      assert result =~ message
    end
  end

  test "Console.parse_option should parse user input into a game option" do
    inputs = [
      {"1\n",    :human_v_human},
      {"1     ", :human_v_human},
      {"1  \n",  :human_v_human},
      {"2\n",    :computer_v_computer},
      {"3\n",    :human_v_computer}
    ]
    for {input, expected} <- inputs do
      assert Console.parse_option(input) == expected
    end
  end

  test "Console.parse_option should return :error for an unrecognized input" do
    input = "hello?"
    result = Console.parse_option(input)
    assert result == :error
  end

  test "Console.get_user_option should prompt user for input and return a parsed response" do
    result = Console.get_user_option(FakeIO)
    assert result == :human_v_human
  end
end
