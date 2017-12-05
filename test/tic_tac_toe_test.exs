defmodule TicTacToeTest do
  use ExUnit.Case
  alias TicTacToe.Board
  alias BoardTestHelper, as: TestHelper

  test "TicTacToe.init should initialize a human_v_human game" do
    player = :player_1
    guess  = 5

    actual   = TicTacToe.init({:human_v_human, :X, :player_1}, FakeIO3)
    board = %Board{player_1: :X, player_2: :O}
    expected = {:human_v_human, {board, guess, player}}

    assert actual == expected
  end

  test "TicTacToe.init should initialize a computer_v_computer game" do
    actual = TicTacToe.init(:computer_v_computer)
    expected = {:computer_v_computer, {%Board{}, 5, :player_1}}
    assert actual == expected
  end

  test "TicTacToe.init should initialize a human_v_computer game" do
    human_player = :player_1
    ai_player    = :player_2
    actual = TicTacToe.init({:human_v_computer, :X, human_player}, FakeIO4)
    expected = {:human_v_computer, {%Board{}, 1, :player_1}, ai_player}
    assert actual == expected
  end

  test "TicTacToe.next should handle the next go of a human_v_human game" do
    current_state = {%Board{}, 1, :player_1}
    expected_board = %Board{} |> Board.update(1, :player_1)
    expected_state = {:human_v_human, {expected_board, 5, :player_2}}

    actual = TicTacToe.next(:human_v_human, current_state, FakeIO3)
    assert actual == expected_state
  end

  test "TicTacToe.next should handle the next go of a computer_v_computer game" do
    current_state = {%Board{}, 5, :player_1}
    expected_board = %Board{} |> Board.update(5, :player_1)
    expected_state = {:computer_v_computer, {expected_board, 1, :player_2}}

    actual = TicTacToe.next(:computer_v_computer, current_state, FakeIO3)
    assert actual == expected_state
  end

  test "TicTacToe.next should handle the next human go of a human_v_computer game" do
    human_player = :player_1
    ai_player    = :player_2

    current_state = {%Board{}, 5, human_player}
    expected_board = %Board{} |> Board.update(5, human_player)
    expected_state = {:human_v_computer, {expected_board, 1, ai_player}, ai_player}

    actual = TicTacToe.next(:human_v_computer, current_state, ai_player, FakeIO3)
    assert actual == expected_state
  end

  test "TicTacToe.next should handle the next computer go of a human_v_computer game" do
    human_player = :player_1
    ai_player    = :player_2

    current_state = {%Board{}, 5, ai_player}
    expected_board = %Board{} |> Board.update(5, ai_player)
    expected_state = {:human_v_computer, {expected_board, 9, human_player}, ai_player}

    actual = TicTacToe.next(:human_v_computer, current_state, ai_player, FakeIO5)
    assert actual == expected_state
  end

  test "TicTacToe.final should render the final output to the screen for human_v_human" do
    expected = """
    ---------------
       X   O   O
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   X
    ---------------
    Player 1 won!
    """
    |> String.trim()
    board = [5,2,1,3,9] |> TestHelper.run_alternating_players(:player_1, %Board{})
    assert TicTacToe.final(:human_v_human, board) =~ expected
  end

  test "TicTacToe.final should render the final output to the screen for computer_v_computer" do
    expected = """
    ---------------
       X   O   O
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   X
    ---------------
    Player 1 won!
    """
    |> String.trim()
    board = [5,2,1,3,9] |> TestHelper.run_alternating_players(:player_1, %Board{})
    assert TicTacToe.final(:computer_v_computer, board) =~ expected
  end

  test "TicTacToe.final should render the final output to the screen for human_v_computer" do
    expected = """
    ---------------
       X   O   O
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   X
    ---------------
    You won!
    """
    |> String.trim()
    human_player = :player_1
    ai_player    = :player_2
    board = [5,2,1,3,9] |> TestHelper.run_alternating_players(human_player, %Board{})
    assert TicTacToe.final(:human_v_computer, board, ai_player) =~ expected

    expected = """
    ---------------
       X   O   O
    ---+---+---+---
       4   X   6
    ---+---+---+---
       7   8   X
    ---------------
    You lost!
    """
    |> String.trim()
    ai_player    = :player_1
    board = [5,2,1,3,9] |> TestHelper.run_alternating_players(ai_player, %Board{})
    assert TicTacToe.final(:human_v_computer, board, ai_player) =~ expected
  end
end
