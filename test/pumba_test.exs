defmodule PumbaTest do
  use ExUnit.Case
  Application.put_env(:tesla, Pumba.Client.DefaultClient, adapter: Tesla.Mock)
end
