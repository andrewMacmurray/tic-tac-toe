defmodule ViewTest do
  use ExUnit.Case
  alias TicTacToe.Console.{Model, View}
  alias TicTacToe.Board
  alias IO.ANSI

  test "View.render_tile should render an individual tile" do
    tiles = [
      {{3, :empty}, "3"},
      {{1, :X},     "X"},
      {{2, :O},     "O"}
    ]
    for {tile, expected} <- tiles do
      actual = View.render_tile(tile) |> ViewTestHelper.strip_ansi()
      assert actual == expected
    end
  end

  test "View.render_row should render a row correctly" do
    row = [{1, :X}, {2, :O}, {3, :empty}]
    expected = "   X   O   3"
    actual   = View.render_row(row) |> ViewTestHelper.strip_ansi()
    assert actual == expected
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
    assert View.render_board(Board.init(3)) == expected

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
    actual =
      [1, 5, 2]
      |> BoardTestHelper.run_alternating_players(:player_1, Board.init(3))
      |> View.render_board()
      |> ViewTestHelper.strip_ansi()
    assert actual == expected
  end

  test "View.render_board renders tiles correctly at a 4x4 scale" do
    expected = """
    -------------------
       1   2   3   4
    ---+---+---+---+---
       5   6   7   8
    ---+---+---+---+---
       9   10  11  12
    ---+---+---+---+---
       13  14  15  16
    -------------------
    """
    |> String.trim()
    assert View.render_board(Board.init(4)) == expected
  end

  test "View.render_board renders tiles with correct colours" do
    x = ANSI.format([:bright, :green, "X"])
    o = ANSI.format([:bright, :blue, "O"])
    expected = """
    ---------------
       #{x}   #{o}   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    """
    |> String.trim()
    actual =
      [1,2]
      |> BoardTestHelper.run_alternating_players(:player_1, Board.init(3))
      |> View.render_board()
    assert actual == expected
  end

  test "View.render_greeting should render a user greeting" do
    result = View.render_greeting()
    greeting_messages = [
      "Welcome to Tic Tac Toe",
      "----------------------"
    ]
    for message <- greeting_messages do
      assert result =~ message
    end
  end

  test "View.move_summary should render human_v_human players correctly" do
    expected = """
    Player 1 took tile 3
    Your turn Player 2
    """
    |> String.trim()
    model = Model.init({:human_v_human, 3})
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
    model = Model.init({:computer_v_computer, 3})
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
    model = Model.init({:human_v_computer, :X, :player_2, 3})
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
    actual =
      Model.init({:human_v_human, 3})
      |> View.render_init()
      |> ViewTestHelper.strip_ansi()
    assert actual == expected
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
    actual =
      Model.init({:computer_v_computer, 3})
      |> View.render_init()
      |> ViewTestHelper.strip_ansi()
    assert actual == expected
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
    actual =
      Model.init({:human_v_computer, :X, :player_1, 3})
      |> View.render_init()
      |> ViewTestHelper.strip_ansi()
    assert actual == expected
  end

  test "View.render_init should render board and message if computer goes first" do
    expected = """
    ---------------
       1   2   3
    ---+---+---+---
       4   5   6
    ---+---+---+---
       7   8   9
    ---------------
    I'll go first, let me think...
    """
    |> String.trim()
    model  = Model.init({:human_v_computer, :X, :player_2, 3})
    assert View.render_init(model) == expected
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
    prev   = Model.init({:human_v_human, 3})
    curr   = prev |> Model.update(5)
    actual = View.render_change(5, prev, curr) |> ViewTestHelper.strip_ansi()
    assert actual == expected
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
    prev = Model.init({:human_v_computer, :X, :player_1, 3})
    curr = prev |> Model.update(5)
    actual = View.render_change(5, prev, curr) |> ViewTestHelper.strip_ansi()
    assert actual == expected
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
    actual =
      Model.init({:human_v_human, 3})
      |> View.render_unrecognized()
      |> ViewTestHelper.strip_ansi()
    assert actual == expected
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
    actual =
      Model.init({:human_v_computer, :X, :player_1, 3})
      |> View.render_unrecognized()
      |> ViewTestHelper.strip_ansi()
    assert actual == expected
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
    actual =
      Model.init({:human_v_human, 3})
      |> Model.update(5)
      |> View.render_invalid()
      |> ViewTestHelper.strip_ansi()
    assert actual == expected
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
    actual =
      Model.init({:human_v_computer, :O, :player_2, 3})
      |> Model.update(5)
      |> View.render_invalid()
      |> ViewTestHelper.strip_ansi()
    assert actual == expected
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
    actual =
      Model.init({:human_v_human, 3})
      |> ModelTestHelper.sequence([5,2,1,3,9])
      |> View.render_terminus()
      |> ViewTestHelper.strip_ansi()
    assert actual == expected
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
    actual =
      Model.init({:human_v_computer, :O, :player_2, 3})
      |> ModelTestHelper.sequence([5,2,1,3,9])
      |> View.render_terminus()
      |> ViewTestHelper.strip_ansi()
    assert actual == expected
  end
end
