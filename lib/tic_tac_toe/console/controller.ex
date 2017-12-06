defmodule TicTacToe.Console.Controller do
  @moduledoc false
  alias TicTacToe.{Model, Board, AI}
  alias TicTacToe.Console.View
  alias IO.ANSI

  @doc """
  Inits a game with given options and runs it to its terminus
  """
  def run_game(options, io \\ IO) do
    options
    |> Model.init()
    |> handle_init(io)
    |> loop(io)
  end

  def loop(model, io) do
    case model.game_status do
      :non_terminal -> handle_guess(model, io) |> loop(io)
      _             -> handle_terminus(model, io)
    end
  end

  @doc """
  Handles the beginning of the game
  """
  def handle_init(model, io \\ IO) do
    if model.next_player == model.ai_player do
      clear_screen(io)
      model
    else
      player_init(model, io)
    end
  end

  defp player_init(model, io) do
    clear_screen(io)
    View.render_init(model) |> io.puts()
    model
  end

  @doc """
  Handles the end of the game
  """
  def handle_terminus(model, io) do
    case model.game_status do
      :non_terminal -> model
      _             -> terminus(model, io)
    end
  end

  defp terminus(model, io) do
    clear_screen(io)
    View.render_terminus(model) |> io.puts()
    model.game_status
  end

  @doc """
  Handles the next move
  """
  def handle_guess(model, io \\ IO) do
    case model.game_type do
      :human_v_human       -> human_guess(model, io)
      :computer_v_computer -> computer_computer_guess(model, io)
      :human_v_computer    -> human_computer_guess(model, io)
    end
  end

  defp human_computer_guess(model, io) do
    if model.next_player == model.ai_player do
      guess = AI.run(model.board, model.ai_player)
      valid_guess(guess, model, io)
    else
      human_guess(model, io)
    end
  end

  defp computer_computer_guess(model, io) do
    guess = AI.run(model.board, model.next_player)
    valid_guess(guess, model, io)
  end

  defp human_guess(model, io) do
    case prompt_guess(io) do
      :error -> unrecognized_guess(model, io)
      guess  -> human_guess_(guess, model, io)
    end
  end

  defp human_guess_(guess, model, io) do
    if Board.empty_at?(model.board, guess) do
      valid_guess(guess, model, io)
    else
      invalid_guess(model, io)
    end
  end

  defp invalid_guess(model, io) do
    clear_screen(io)
    View.render_invalid(model) |> io.puts()
    model
  end

  defp unrecognized_guess(model, io) do
    clear_screen(io)
    View.render_unrecognized(model) |> io.puts()
    model
  end

  defp valid_guess(guess, model, io) do
    clear_screen(io)
    next_model = Model.update(model, guess)
    View.render_change(guess, model, next_model) |> io.puts()
    next_model
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

  def clear_screen(io), do: ANSI.format([:clear, :home]) |> io.puts()
end
