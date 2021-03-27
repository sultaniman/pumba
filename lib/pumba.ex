defmodule Pumba do
  @moduledoc """
  Documentation for `Pumba`
  """
  alias Pumba.UserAgents

  @doc """
  Fetch and load user agents for a given browser.
  """
  @spec load(String.t()) :: :ok
  def load(browser) do
    UserAgents.load(browser)
  end

  @doc """
  Override default client with your own client.
  """
  @spec set_client(module()) :: :ok
  def set_client(client) do
    UserAgents.set_client(client)
  end

  @doc """
  Get current state.
  """
  @spec all :: map()
  def all, do: UserAgents.all()

  @doc """
  Fetch random user agent.
  """
  @spec random :: String.t() | nil
  def random, do: UserAgents.random()

  @doc """
  Check if user agents for a given browser were loaded
  """
  @spec ready?(String.t()) :: boolean()
  def ready?(browser), do: UserAgents.ready?(browser)

  @doc """
  Get list of user agents for browser
  """
  @spec get(String.t()) :: [String.t()]
  def get(browser), do: UserAgents.get(browser)
end
