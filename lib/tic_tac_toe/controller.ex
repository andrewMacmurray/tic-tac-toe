defmodule TicTacToe.Controller do
  @moduledoc false
  alias TicTacToe.{State, Board, AI}
  alias TicTacToe.Console.Render
  alias IO.ANSI

  @doc """
  Handles the beginning of the game
  """
  def handle_init(state, io \\ IO) do
    case state.game_type do
      :human_v_human       -> same_player_type_init(state, io)
      :computer_v_computer -> same_player_type_init(state, io)
      :human_v_computer    -> human_computer_init(state, io)
    end
  end

  defp same_player_type_init(state, io) do
    clear_screen() |> io.puts()
    render_state = Render.init_message(state.game_type, state.board, state.next_player)
    render_state |> io.puts()
    state
  end

  defp human_computer_init(state, io) do
    clear_screen() |> io.puts()
    if state.next_player == state.ai_player do
      state
    else
      render_state = Render.init_message(state.game_type, state.board, state.next_player)
      render_state |> io.puts()
      state
    end
  end

  @doc """
  Handles the end of the game
  """
  def handle_terminus(state, io \\ IO) do
    case state.game_type do
      :human_v_human       -> same_player_type_terminus(state, io)
      :computer_v_computer -> same_player_type_terminus(state, io)
      :human_v_computer    -> human_computer_terminus(state, io)
    end
  end

  defp human_computer_terminus(state, io) do
    case state.game_status do
      :non_terminal -> state
      _             -> human_computer_terminus_(state, io)
    end
  end

  defp same_player_type_terminus(state, io) do
    case state.game_status do
      :non_terminal -> state
      _             -> same_player_type_terminus_(state, io)
    end
  end

  defp human_computer_terminus_(state, io) do
    clear_screen() |> io.puts()
    render_state = Render.render_final(state.game_type, state.board, state.ai_player)
    render_state |> io.puts()
    state.game_status
  end

  defp same_player_type_terminus_(state, io) do
    clear_screen() |> io.puts()
    render_state = Render.render_final(state.game_type, state.board)
    render_state |> io.puts()
    state.game_status
  end

  @doc """
  Handles the next move
  """
  def handle_guess(state, io \\ IO) do
    case state.game_type do
      :human_v_human       -> handle_human_guess(state, io)
      :computer_v_computer -> handle_computer_computer_guess(state, io)
      :human_v_computer    -> handle_human_computer_guess(state, io)
    end
  end

  defp handle_human_computer_guess(state, io) do
    if state.next_player == state.ai_player do
      guess = AI.run(state.board, state.ai_player)
      human_computer_guess(guess, state, io)
    else
      case prompt_guess(io) do
        :error -> unrecognized_guess(state, io)
        guess  -> handle_human_computer_human_guess(guess, state, io)
      end
    end
  end

  defp handle_computer_computer_guess(state, io) do
    guess = AI.run(state.board, state.next_player)
    valid_guess(guess, state, io)
  end

  defp handle_human_guess(state, io) do
    case prompt_guess(io) do
      :error -> unrecognized_guess(state, io)
      guess  -> handle_human_guess_(guess, state, io)
    end
  end

  defp handle_human_computer_human_guess(guess, state, io) do
    if Board.empty_at?(state.board, guess) do
      human_computer_guess(guess, state, io)
    else
      invalid_guess(state, io)
    end
  end

  defp handle_human_guess_(guess, state, io) do
    if Board.empty_at?(state.board, guess) do
      valid_guess(guess, state, io)
    else
      invalid_guess(state, io)
    end
  end

  defp invalid_guess(state, io) do
    clear_screen() |> io.puts()
    render_state = Render.render_invalid(state.game_type, state.board, state.next_player)
    render_state |> io.puts()
    state
  end

  defp unrecognized_guess(state, io) do
    clear_screen() |> io.puts()
    render_state = Render.render_unrecognized(state.game_type, state.board, state.next_player)
    render_state |> io.puts()
    state
  end

  defp valid_guess(guess, state, io) do
    clear_screen() |> io.puts()
    next_state   = State.update(state, guess)
    render_state = Render.render_change(state.game_type, next_state.board, guess, state.next_player)
    render_state |> io.puts()
    next_state
  end

  defp human_computer_guess(guess, state, io) do
    clear_screen() |> io.puts()
    next_state = State.update(state, guess)
    render_state = Render.render_change(:human_v_computer, next_state.board, guess, state.next_player, state.ai_player)
    render_state |> io.puts()
    next_state
  end

  defp prompt_guess(io) do
    io.gets("> ") |> parse_guess!()
  end

  def parse_guess!(guess) do
    case Integer.parse(guess) do
      :error -> :error
      {n, _} -> n
    end
  end

  def clear_screen, do: ANSI.format([:clear, :home])
end
