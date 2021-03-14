defmodule Pumba.UserAgents do
  @moduledoc false
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

  @spec all :: term()
  def all, do: GenServer.call(@mod, :all)

  @spec random :: term()
  def random, do: GenServer.call(@mod, :random)

  @doc false
  @spec set_client(module()) :: :ok
  def set_client(client) do
    GenServer.cast(@mod, {:set_client, client})
  end

  @doc false
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

  @impl true
  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:random, _from, %{names: names, browsers: browsers} = state) do
    ts = DateTime.now!("Etc/UTC") |> DateTime.to_unix()
    :rand.seed(:exsss, {ts+1, ts+2, ts+3})

    result =
      browsers
      |> Map.get(names |> Enum.random())

    n = Enum.random(0..result.count)

    {:reply, result.user_agents[n], state}
  end

  defp process_result(user_agents) do
    user_agents
    |> Enum.with_index()
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Enum.into(%{})
  end
end
