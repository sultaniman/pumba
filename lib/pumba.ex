defmodule Pumba do
  @moduledoc """
  Documentation for `Pumba`
  """
  alias Pumba.UserAgents

  @spec load(String.t()) :: :ok
  def load(browser) do
    UserAgents.load(browser)
  end

  @spec set_client(module()) :: :ok
  def set_client(client) do
    UserAgents.set_client(client)
  end

  def all, do: UserAgents.all()

  def random, do: UserAgents.random()
end
