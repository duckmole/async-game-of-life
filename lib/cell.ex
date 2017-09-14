defmodule Cell do
  use GenServer

  ## server

  def init_with_neighbours({neighbours, cell_state}) do
    {:ok, {neighbours, {0, cell_state, []}}}
  end

  def handle_cast(message, {neighbours, {round, state, neighbour_states}}) do
    new_neighbour_states = [message|neighbour_states]
    new_turn = (length(neighbours) == length(new_neighbour_states))
    {:noreply, {neighbours, new_state(new_turn, round, state, new_neighbour_states)}}
  end

  def new_state(true, round, state, neighbour_states) do
    alive_neighbours = length( Enum.filter(neighbour_states, fn({_,neighbour_state}) -> neighbour_state == :alive end))
    {(round+1), resolve_state(alive_neighbours, state), []}
  end

  def new_state(false, round, state, neighbour_states) do
    {round, state, neighbour_states}
  end

  def resolve_state(3, _) do
    :alive
  end

  def resolve_state(2, :alive) do
    :alive
  end

  def resolve_state(2, :dead) do
    :dead
  end

  def resolve_state(_,state) do
    :dead
  end

end
