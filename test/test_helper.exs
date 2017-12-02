helper_files = [
  "fake_io.exs",
  "board_helper.exs",
  "ui_helper.exs"
]

for f <- helper_files do
  Code.require_file(f, "test/support/")
end

ExUnit.start()
