defmodule OptionsTest do
  use ExUnit.Case
  alias TicTacToe.Console.Options

  test "Options.show_game_options should print the possible game types" do
    result = Options.show_game_options(OptionIO1)
    messages = [
      "Select a game to play:",
      "1. Human vs Human        💁  vs 💁",
      "2. Computer vs Computer  🤖  vs 🤖",
      "3. Human vs Computer     💁  vs 🤖",
      "----------------------"
    ]
    for message <- messages do
      assert result =~ message
    end
  end

  test "Options.parse_game_option should parse user input into a game option" do
    inputs = [
      {"1\n",    :human_v_human},
      {"1     ", :human_v_human},
      {"1  \n",  :human_v_human},
      {"2\n",    :computer_v_computer},
      {"3\n",    :human_v_computer}
    ]
    for {input, expected} <- inputs do
      assert Options.parse_game_option(input) == expected
    end
  end

  test "Options.parse_game_option should return :error for unrecognized input" do
    input = "hello?"
    result = Options.parse_game_option(input)
    assert result == :error
  end

  test "Options.get_game_option should prompt user for input and return a parsed response" do
    result = Options.get_game_option(OptionIO3)
    assert result == :human_v_computer
  end

  test "Options.parse_tile_symbol should parse user input into a tile type" do
    inputs = [
      {"X\n",      :X},
      {"x\n",      :X},
      {"X     \n", :X},
      {"x     ",   :X},
      {"o\n",      :O},
      {"O   ",     :O},
      {"0\n",      :O}
    ]
    for {input, expected} <- inputs do
      assert Options.parse_tile_symbol(input) == expected
    end
  end

  test "Options.parse_tile_symbol should return :error for unrecognized input" do
    input = "U"
    result = Options.parse_tile_symbol(input)
    assert result == :error
  end

  test "Options.get_tile_symbol should prompt user for tile symbol and return a parsed response" do
    result = Options.get_tile_symbol(OptionIO3)
    assert result == :X
  end

  test "Options.parse_player should parse user input into player_1 or player_2" do
    inputs = [
      {"Y\n",     :player_1},
      {"y\n",     :player_1},
      {"Yes\n",   :player_1},
      {"YES\n",   :player_1},
      {"y    \n", :player_1},
      {"N\n",     :player_2},
      {"n\n",     :player_2},
      {"No\n",    :player_2},
      {"NO\n",    :player_2},
      {"n    \n", :player_2},
    ]
    for {input, expected} <- inputs do
      assert Options.parse_player(input) == expected
    end
  end

  test "Options.parse_player should return :error for unrecognized input" do
    input = "What?"
    result = Options.parse_player(input)
    assert result == :error
  end

  test "Options.get_player should prompt user for player choice and return a parsed result" do
    result = Options.get_player(OptionIO3)
    assert result == :player_1
  end

  test "Options.retry_on_error should call the given function if :error is passed to it" do
    result = Options.retry_on_error(:error, fn _ -> :another_value end, OptionIO3)
    assert result == :another_value
  end

  test "Options.retry_on_error should return any non error value" do
    result = Options.retry_on_error(:player_2, fn _ -> :some_other_value end, OptionIO3)
    assert result == :player_2
  end

  test "Options.human_v_computer should return options for human_v_computer game" do
    result = Options.human_v_computer(OptionIO3)
    assert result == {:human_v_computer, :X, :player_1}
  end

  test "Options.get should greet the user and parse all input into correct game options" do
    states = [
      {OptionIO3, {:human_v_computer, :X, :player_1}},
      {OptionIO1, :human_v_human},
      {OptionIO2, :computer_v_computer}
    ]
    for {effect_module, expected} <- states do
      result = Options.get(effect_module)
      assert result == expected
    end
  end
end
