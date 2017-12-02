defmodule UiTestHelper do
  def retry_after_error(io) do
    io.puts("something went wrong")
    :value_after_error
  end
end
