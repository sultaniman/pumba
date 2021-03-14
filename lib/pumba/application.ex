defmodule Pumba.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [Pumba.UserAgents]
    Supervisor.start_link(children, strategy: :one_for_one, name: Pumba.Supervisor)
  end
end
