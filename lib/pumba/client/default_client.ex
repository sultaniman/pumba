defmodule Pumba.Client.DefaultClient do
  @moduledoc """
  Default client uses http://www.useragentstring.com
  """
  @behaviour Pumba.Client

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://www.useragentstring.com")

  @impl true
  def load(browser) do
    case get(["/pages/useragentstring.php?name=", browser] |> to_string()) do
      {:ok, response} ->
        {
          :ok,
          response.body
          |> Floki.find("#liste > ul > li > a")
          |> Enum.map(&Floki.text/1)
        }

      error ->
        error
    end
  end
end
