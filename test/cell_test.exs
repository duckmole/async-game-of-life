defmodule CellTest do
  use ExUnit.Case
  doctest Cell

  test "start cell process with its name and state" do
    state = :alive
    neighbours = [:p_0_1, :p_0_1]
    init_state = {neighbours, {0, :alive, []}}
    assert {:ok, init_state} == Cell.init({neighbours, state})
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

