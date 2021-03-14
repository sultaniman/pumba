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
        browsers: %{}
      }
    )
  end

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
  def handle_cast({:load, browser_name}, %{client: client, browsers: browsers} = state) do
    case client.load(browser_name) do
      {:ok, user_agents} ->
        {
          :noreply,
          %{
            state
            | browsers:
                Map.put(browsers, browser_name, %Result{
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
                Map.put(browsers, browser_name, %Result{
                  error: err,
                  count: 0,
                  user_agents: %{}
                })
          }
        }
    end
  end

  defp process_result(user_agents) do
    user_agents
    |> Enum.with_index()
    |> Enum.into(%{})
  end
end
