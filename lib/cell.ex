defmodule Cell do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def handle_cast(msg, state) do
    {:noreply, state}
  end

end
