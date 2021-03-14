defmodule Pumba.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Pumba.Worker.start_link(arg)
      # {Pumba.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: Pumba.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
