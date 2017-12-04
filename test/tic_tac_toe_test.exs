defmodule TicTacToeTest do
  use ExUnit.Case
  alias TicTacToe.Board
  alias BoardTestHelper, as: TestHelper

  test "TicTacToe.init should initialize a human_v_human game" do
    player = :player_1
    guess  = 5

    actual   = TicTacToe.init({:human_v_human, :X, :player_1}, FakeIO3)
    board = %Board{player_1: :X, player_2: :O}
    expected = {board, guess, player}

    assert actual == expected
  end

  test "TicTacToe.init should initialize a computer_v_computer game" do
    actual = TicTacToe.init(:computer_v_computer)
    expected = {%Board{}, 5, :player_1}
    assert actual == expected
  end

  test "TicTacToe.next should handle the next go of a human_v_human game" do
    current_state = {%Board{}, 1, :player_1}
    expected_board = %Board{} |> Board.update(1, :player_1)
    expected_state = {expected_board, 5, :player_2}

    actual = TicTacToe.next(current_state, FakeIO3)
    assert actual == expected_state
  end

  test "TicTacToe.final should render the final output to the screen" do
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
end
