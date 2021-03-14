defmodule Pumba.Result do
  @moduledoc false
  use TypedStruct

  typedstruct do
    @typedoc "Result of request"
    field :error, any
    field :count, integer()
    field :user_agents, map()
  end
end
