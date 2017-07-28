defmodule Cell do
  use GenServer

  ## server

  def init({position, state}) do
    {:ok, {position, {0, state, []}}}
  end

  def handle_cast({_,{_,neighbour_state}}, {position, {round, state, neighbours}}) do
    new_state = new_state(round, state, [neighbour_state | neighbours])
    {:noreply, {position, new_state}}
  end

  def new_state(round, state, neighbours) when is_list(neighbours) do
    nb_alive = length(Enum.filter(neighbours, fn(x) -> x == :alive end))
    new_state(round, state, nb_alive)
  end

  def new_state(round, :alive, 2) do
    {round+1, :alive, []}
  end

  def new_state(round, _, 3) do
    {round+1, :alive, []}
  end

  def new_state(round, _, _) do
    {round+1, :dead, []}
  end

end
