defmodule Pumba.Client do
  @moduledoc """
  Base client behavior
  """

  @doc """
  Load the list of user agents
  """
  @callback load(String.t()) :: {:ok, [String.t()]} | {:error, any}
end
