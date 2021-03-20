defmodule Pumba.UserAgents do
  @moduledoc """
  Worker retrieves user agents for different browsers
  and provides random access to user agen strings.

  Maintained state looks like

  ```ex
    %{
      client: Pumba.Client.DefaultClient,
      browsers: %{},
      names: []
    }
  ```

  Where `browsers` is a map with key as browser
  and the list user agents as value, `names` is
  a list of loaded browsers using which we later
  can randomly pick browser and return a random user agent.

  `browsers` contains `%Pumba.Result{}` record which keeps
  total count of user agents and indexed map with user
  agent strings for fast lookups.

  It uses `Pumba.Client.DefaultClient` which loads
  user agent strings from http://www.useragentstring.com.

  You can also specify you custom client via configuration

  ```ex
  config :pumba,
    client: MyAwesomeClient
  ```

  Also you can override client using `Pumba.UserAgents.set_client(MyAwesomeClient)`
  and clients should implement `Pumba.Client` behaviour.

  To load user agents list for a given browser you need to call `Pumba.UserAgents.load/1`.
  """
  use GenServer, restart: :transient
  alias Pumba.Result
  alias Pumba.Client.DefaultClient

  @mod __MODULE__

  # Client
  def start_link(_) do
    GenServer.start_link(
      @mod,
      %{
        client: Application.get_env(:pumba, :client, DefaultClient),
        browsers: %{},
        names: []
      },
      name: @mod
    )
  end

  @doc """
  Return current state.
  """
  @spec all :: map()
  def all, do: GenServer.call(@mod, :all)

  @doc """
  Returns random user agent string.
  """
  @spec random :: term()
  def random, do: GenServer.call(@mod, :random)

  @doc """
  Replace client to retrieve user agents
  """
  @spec set_client(module()) :: :ok
  def set_client(client) do
    GenServer.cast(@mod, {:set_client, client})
  end

  @doc """
  Asynchronously load user agents for given browser.
  """
  @spec load(String.t()) :: :ok
  def load(browser) do
    GenServer.cast(@mod, {:load, browser})
  end

  # Server
  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:set_client, client}, state) do
    {:noreply, %{state | client: client}}
  end

  @doc false
  @impl true
  def handle_cast({:load, name}, %{client: client, browsers: browsers, names: names} = state) do
    case client.load(name) do
      {:ok, user_agents} ->
        loaded =
          names
          |> MapSet.new()
          |> MapSet.put(name)

        {
          :noreply,
          %{
            state
            | names: loaded |> MapSet.to_list(),
              browsers:
                Map.put(browsers, name, %Result{
                  count: length(user_agents),
                  user_agents: process_result(user_agents)
                })
          }
        }

      {:error, err} ->
        {
          :noreply,
          %{
            state
            | browsers:
                Map.put(browsers, name, %Result{
                  error: err,
                  count: 0,
                  user_agents: %{}
                })
          }
        }
    end
  end

  @doc false
  @impl true
  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  @doc false
  @impl true
  def handle_call(:random, _from, %{names: names, browsers: browsers} = state) do
    ts = DateTime.now!("Etc/UTC") |> DateTime.to_unix()
    :rand.seed(:exsss, {ts + 1, ts + 2, ts + 3})

    case browsers |> Map.get(names |> Enum.random()) do
      nil ->
        {:reply, nil, state}

      result ->
        n = Enum.random(0..(result.count - 1))
        {:reply, result.user_agents[n], state}
    end
  end

  defp process_result(user_agents) do
    user_agents
    |> Enum.with_index()
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Enum.into(%{})
  end
end
