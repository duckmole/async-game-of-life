# Async Game of Life

Try to implement game of life in elixir with process and asyn messages

We plan to do this session on Thursday 10 August

## OTP and elixir

We will use GenServer for each cell. We have to define

* `init/1` to initialise the state of our cell : https://hexdocs.pm/elixir/GenServer.html#c:init/1
* `handle_cast/2` for async messages received by the cell : https://hexdocs.pm/elixir/GenServer.html#c:handle_cast/2


init(args)
```
init(args :: term) ::
  {:ok, state} |
  {:ok, state, timeout | :hibernate} |
  :ignore |
  {:stop, reason :: any} when state: any
```

handle_cast(request, state)
```
handle_cast(request :: term, state :: term) ::
  {:noreply, new_state} |
  {:noreply, new_state, timeout | :hibernate} |
  {:stop, reason :: term, new_state} when new_state: term
```
