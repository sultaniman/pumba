<p align="center">
  <img width="250" src="https://raw.githubusercontent.com/imanhodjaev/pumba/main/assets/pumbaa.jpeg"/>
</p>

![Tests](https://github.com/imanhodjaev/pumba/actions/workflows/pumba.yml/badge.svg)
![Lint](https://github.com/imanhodjaev/pumba/actions/workflows/lint.yml/badge.svg)

Pumba helps you

1. To fetch user agent strings for different browsers,
2. Keep in-memory state,
3. Randomly fetch any user agent,
4. Profit - Hakuna Matata 🦄

## Use cases 🔮

You might want to use `Pumba`

1. To simulate real user agent when requesting website or resource,
2. To use in tandem with crawlers to randomly swap user agent strings,
3. Build REST API or any API on top of it or expose as a service,
4. Many other use cases I'm not aware (open issue to share one).

## Installation 💾

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pumba` to your list of dependencies in `mix.exs` and if needed please add to
application list to start:

```elixir
def deps do
  [
    {:pumba, "~> 0.0.2"}
  ]
end
```

## Usage 🧠

### Load user agents

To load user agent strings for a given browser you need to call

```ex
iex> Pumba.load("Firefox")
:ok
```

### Get random user agent

To load user agent strings for a given browser you need to call

```ex
iex> Pumba.random()
Mozilla/5.0 (X11; Linux ppc64le; rv:75.0) Gecko/20100101 Firefox/75.0
```

### Check if user agents loaded

```ex
iex> Pumba.ready?("Firefox")
true
```

### Get user agents for browser

```ex
iex> Pumba.get("Firefox")
[
  "Mozilla/5.0 (X11; Linux ppc64le; rv:75.0) Gecko/20100101 Firefox/75.0",
  ...
]
```

### Set custom client

Default client fetches user agents from http://www.useragentstring.com.

There are two ways to set custom client first is via config second is overriding manually

Configuration

```ex
config :pumba,
  client: MyAwesomeClient
```

Runtime

```ex
iex> Pumba.set_client(MyAwesomeClient)
```

### Create custom client

If you want to have your own client then it should implement `Pumba.Client` behaviour.

### User agents storage

Storage is a GenServer which has the following state and lives at `Pumba.UserAgents`

```ex
%{
  client: Pumba.Client.DefaultClient,
  browsers: %{},
  names: []
}
```

Where `browsers` is a map with key as browser name and the list user agents
as it's value, `names` is a list of loaded browsers using which we later can
randomly pick browser and return a random user agent.

`browsers` contains `%Pumba.Result{}` record which keeps total count of user
agents and indexed map with user agent strings for fast lookups.

## Get current state

To get the latest state you can use `Pumba.all/0` function.

## Documentation 📜

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/pumba](https://hexdocs.pm/pumba).

## Assets 💄

https://www.flickr.com/photos/15622979@N07/4329873905
