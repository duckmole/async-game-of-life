defmodule CellTest do
  use ExUnit.Case
  doctest Cell

  test "start cell process with its name and state" do
    init_state = {{1,2}, {0, :alive}}
    assert {:ok, init_state} == Cell.init(init_state)
  end

  test "deal with received message" do
    state = {}
    assert {:noreply, state} == Cell.handle_cast(:toto, state)
  end
end
