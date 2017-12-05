defmodule ConsoleViewTest do
  use ExUnit.Case
  alias TicTacToe.Console.View
  alias TicTacToe.{Board, Model}
  alias BoardTestHelper, as: TestHelper

  test "View.render_tile should render an individual tile" do
    tiles = [
      {{3, :empty}, "3"},
      {{1, :X},     "X"},
      {{2, :O},     "O"}
    ]
    for {tile, expected} <- tiles do
      assert View.render_tile(tile) == expected
    end
  end

  test "View.render_row should render a row correctly" do
    row = [{1, :X}, {2, :O}, {3, :empty}]
    expected = "   X   O   3"
    assert View.render_row(row) == expected
  end

  test "View.render_board should render a board correctly" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    """
    |> String.trim()
    assert View.render_board(%Board{}) == expected

    expected = """
    ---------------
       X   X   3
    ---+---+---+---
       4   O   6
    ---+---+---+---
       7   8   9
    ---------------
    """
    |> String.trim()
    board =
      [1, 5, 2] |> TestHelper.run_alternating_players(:player_1, %Board{})
    assert View.render_board(board) == expected
  end

  test "View.move_summary should render human_v_human players correctly" do
    expected = """
    Player 1 took tile 3
    Your turn Player 2
    """
    |> String.trim()
    model = Model.init({:human_v_human, :X, :player_1})
    assert View.move_summary(3, model) == expected

    expected = """
    Player 2 took tile 3
    Your turn Player 1
    """
    |> String.trim()
    model = model |> Model.update(5)
    assert View.move_summary(3, model) == expected
  end

  test "View.move_summary should render computer_v_computer players correctly" do
    expected = """
    Player 1 took tile 5
    Your turn Player 2
    """
    |> String.trim()
    model = Model.init(:computer_v_computer)
    assert View.move_summary(5, model) == expected

    expected = """
    Player 2 took tile 7
    Your turn Player 1
    """
    |> String.trim()
    model = model |> Model.update(5)
    assert View.move_summary(7, model) == expected
  end

  test "View.move_summary should render human_v_computer players correctly" do
    expected = """
    Ok, I'll take tile 1
    Your turn
    """
    |> String.trim()
    model = Model.init({:human_v_computer, :X, :player_2})
    assert View.move_summary(1, model) == expected

    expected = """
    You took tile 5
    Ok, I'll go next
    """
    |> String.trim()
    model = model |> Model.update(1)
    assert View.move_summary(5, model) == expected
  end

  test "View.render_init should show first board and instructions for human_v_human" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    Your turn Player 1
    """
    |> String.trim()
    model = Model.init({:human_v_human, :X, :player_1})
    assert View.render_init(model) == expected
  end

  test "View.render_init should show first board and instructions for computer_v_computer" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    Your turn Player 1
    """
    |> String.trim()
    model = Model.init(:computer_v_computer)
    assert View.render_init(model) == expected
  end

  test "View.render_init should show first board and instructions for human_v_computer" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    Your turn
    """
    |> String.trim()
    model = Model.init({:human_v_computer, :X, :player_1})
    assert View.render_init(model) == expected
  end

  test "View.render_init should show nothing if computer goes first" do
    model  = Model.init({:human_v_computer, :X, :player_2})
    assert View.render_init(model) == ""
  end

  test "View.render_change should render the board and a summary of the move made" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   9
    ---------------
    Player 1 took tile 5
    Your turn Player 2
    """
    |> String.trim()
    prev = Model.init({:human_v_human, :X, :player_1})
    curr = prev |> Model.update(5)
    assert View.render_change(5, prev, curr) == expected
  end

  test "View.render_change should render the board and a summary of the move made in a human_v_computer game" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   9
    ---------------
    You took tile 5
    Ok, I'll go next
    """
    |> String.trim()
    prev = Model.init({:human_v_computer, :X, :player_1})
    curr = prev |> Model.update(5)
    assert View.render_change(5, prev, curr) == expected
  end

  test "View.render_unrecognized should render the board and a message that the user made an unrecognized guess for human_v_human" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    Player 1, number not recognized
    Please enter a number 1-9
    """
    |> String.trim()
    model = Model.init({:human_v_human, :X, :player_1})
    assert View.render_unrecognized(model) == expected
  end

  test "View.render_unrecognized should render the board and a message that the user made an unrecognized guess for human_v_computer" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    Number not recognized
    Please enter a number 1-9
    """
    |> String.trim()
    model = Model.init({:human_v_computer, :X, :player_1})
    assert View.render_unrecognized(model) == expected
  end

  test "View.render_invalid should render the board and a message that the user made an invalid guess for a human_v_human game" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   9
    ---------------
    Player 2, that tile has already been taken
    Please enter a valid guess
    """
    |> String.trim()
    model = Model.init({:human_v_human, :X, :player_1}) |> Model.update(5)
    assert View.render_invalid(model) == expected
  end

  test "View.render_invalid should render the board and a message that the user made an invalid guess for a human_v_computer game" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   9
    ---------------
    That tile has already been taken
    Please enter a valid guess
    """
    |> String.trim()
    model = Model.init({:human_v_computer, :O, :player_2}) |> Model.update(5)
    assert View.render_invalid(model) == expected
  end

  test "View.render_terminus should render the result of a terminal human_v_human game" do
    expected = """
    ---------------
       X   O   O
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   X
    ---------------
    Player 1 won! 🎉
    """
    |> String.trim()
    model = Model.init({:human_v_human, :X, :player_1})
      |> Model.update(5)
      |> Model.update(2)
      |> Model.update(1)
      |> Model.update(3)
      |> Model.update(9)
    assert View.render_terminus(model) == expected
  end

  test "View.render_terminus should render the result of a terminal human_v_computer game" do
    expected = """
    ---------------
       X   O   O
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   X
    ---------------
    You lost! 😢
    """
    |> String.trim()
    model = Model.init({:human_v_computer, :O, :player_2})
      |> Model.update(5)
      |> Model.update(2)
      |> Model.update(1)
      |> Model.update(3)
      |> Model.update(9)
    assert View.render_terminus(model) == expected
  end
end
