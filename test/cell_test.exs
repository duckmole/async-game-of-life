defmodule CellTest do
  use ExUnit.Case
  doctest Cell

  test "start cell process with its name and state" do
    position = {1,2}
    state = :alive
    init_state = {position, {0, :alive, []}}
    assert {:ok, init_state} == Cell.init({position, state})
  end

  test "deal with received message" do
    state = {{1,2}, {0, :alive, []}}
    cell = {0,0}
    msg = {cell, {0, :dead}}
#    {:noreply, {{1,2}, {0, :alive, [:dead]}}} = Cell.handle_cast(msg, state)
  end

  describe "Update state" do
    test "rule 1" do
      neighbours = List.duplicate(:dead, 8)
      assert {1, :dead, []} == Cell.new_state(0, :alive, neighbours)
    end

    test "rule 2" do
      neighbours = List.duplicate(:alive, 4) ++ List.duplicate(:dead, 4)
      assert {1, :dead, []} == Cell.new_state(0, :alive, neighbours)
    end

    test "rule 3" do
      neighbours = [:alive, :alive] ++ List.duplicate(:dead, 4)
      assert {1, :alive, []} == Cell.new_state(0, :alive, neighbours)
    end

    test "rule 3 bis" do
      neighbours = [:alive, :alive, :alive] ++ List.duplicate(:dead, 4)
      assert {1, :alive, []} == Cell.new_state(0, :alive, neighbours)
    end

    test "rule 4" do
      neighbours = [:alive, :alive] ++ List.duplicate(:dead, 4)
      assert {1, :dead, []} == Cell.new_state(0, :dead, neighbours)
    end

    test "rule 4 bis" do
      neighbours = [:alive, :alive, :alive] ++ List.duplicate(:dead, 4)
      assert {1, :alive, []} == Cell.new_state(0, :dead, neighbours)
    end

  end
end
