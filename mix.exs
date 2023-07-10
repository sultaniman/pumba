defmodule Pumba.MixProject do
  @moduledoc false
  use Mix.Project

  @package [
    name: "pumba",
    files: ~w(lib assets .formatter.exs mix.exs README* LICENSE*),
    licenses: ["Unlicense"],
    links: %{"GitHub" => "https://github.com/imanhodjaev/pumba"}
  ]

  @description "Fetch, store and access user agent strings for different browsers"

  def project do
    [
      app: :pumba,
      version: "0.0.2",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      package: @package,

      # Docs
      name: "Pumba",
      source_url: "https://github.com/imanhodjaev/pumba",
      homepage_url: "https://github.com/imanhodjaev/pumba",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Pumba.Application, []}
    ]
  end

  defp deps do
    [
      {:floki, "~> 0.34.0"},
      {:tesla, "~> 1.4"},
      {:typed_struct, "~> 0.2.1"},
      {:ex_doc, "~> 0.30.1", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:inch_ex, github: "rrrene/inch_ex", only: [:dev, :test]},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
