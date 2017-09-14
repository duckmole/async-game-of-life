defmodule CellTest do
  use ExUnit.Case, async: true
  doctest Cell

  describe "business logic" do

    test "start cell process with its name and state" do
      state = :alive
      neighbours = [:p_0_1, :p_0_1]
      init_state = {neighbours, {0, :alive, []}}
      assert {:ok, init_state} == Cell.init_with_neighbours({neighbours, state})
    end

    test "store neighbour state" do
      state = {[:p1, :p2, :p3], {1, :alive, []}}
      {:noreply, {[:p1, :p2, :p3], {1, :alive, neighbours}}} = Cell.handle_cast({1, :alive}, state)
      assert [{1, :alive}] == neighbours
    end

    test "change state" do
      neighbours = [:p1, :p2, :p3]
      neighbour_states = [{1, :alive}, {1, :dead}]
      state = {neighbours, {1, :alive, neighbour_states}}
      {:noreply, {neighbours, {2, new_state, []}}} = Cell.handle_cast({1, :alive}, state)
    end

    test "staying alive" do
      neighbour_states = [{1, :alive}, {1, :dead}, {1, :alive}]
      assert {2, :alive, []} == Cell.new_state(true, 1, :alive, neighbour_states)
    end

    test "staying dead" do
      neighbour_states = [{1, :alive}, {1, :dead}, {1, :alive}]
      assert {2, :dead, []} == Cell.new_state(true, 1, :dead, neighbour_states)
    end

    test "rise from the dead" do
      neighbour_states = [{1, :alive}, {1, :alive}, {1, :alive}]
      assert {2, :alive, []} == Cell.new_state(true, 1, :dead, neighbour_states)
    end

    test "die from overcrowding" do
      neighbour_states = [{1, :alive}, {1, :alive}, {1, :alive}, {1, :alive}]
      assert {2, :dead, []} == Cell.new_state(true, 1, :alive, neighbour_states)
    end

    test "die from starvation" do
      neighbour_states = [{1, :dead}, {1, :dead}, {1, :alive}]
      assert {2, :dead, []} == Cell.new_state(true, 1, :alive, neighbour_states)
    end
  end

  describe "server test" do

    @tag :skip
    test "cell with one neighbour alive" do
      {:ok, cell} = start_supervised({Cell, :alive})
      Cell.set_neighbours(cell, [:neighbours])
      Cell.send_state(cell, {1, :alive})
      assert {1, :dead} == Cell.state(cell)
    end

    @tag :skip
    test "cell with four neighbour alive" do
      {:ok, cell} = start_supervised({Cell, :alive})
      Cell.set_neighbours(cell, [:n1, :n2, :n3, :n4])
      Cell.send_state(cell, {1, :alive})
      assert {0, :alive} == Cell.state(cell)
      Cell.send_state(cell, {1, :alive})
      Cell.send_state(cell, {1, :alive})
      assert {0, :alive} == Cell.state(cell)
      Cell.send_state(cell, {1, :alive})
      assert {1, :dead} == Cell.state(cell)
    end

    @tag :skip
    test "cell with one neighbour all dbecome dead" do
      {:ok, cell1} = GenServer.start_link(Cell, :alive)
      {:ok, cell2} = GenServer.start_link(Cell, :alive)
      Cell.set_neighbours(cell1, [cell2])
      Cell.set_neighbours(cell2, [cell1])
      assert {0, :alive} == Cell.state(cell1)
      assert {0, :alive} == Cell.state(cell2)
      Cell.send_state(cell1, {1, :alive})
      assert {1, :dead} == Cell.state(cell1)
      assert {1, :dead} == Cell.state(cell2)
    end
  end

end
