defmodule Pumba.MixProject do
  use Mix.Project

  def project do
    [
      app: :pumba,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Pumba.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:floki, "~> 0.30.0"},
      {:tesla, "~> 1.4"},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
