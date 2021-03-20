defmodule UserAgentTest do
  @moduledoc false
  use ExUnit.Case
  import Tesla.Mock
  alias Pumba.UserAgents

  @user_agents [
    "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:77.0) Gecko/20190101 Firefox/77.0",
    "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:77.0) Gecko/20100101 Firefox/77.0",
    "Mozilla/5.0 (X11; Linux ppc64le; rv:75.0) Gecko/20100101 Firefox/75.0",
    "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:39.0) Gecko/20100101 Firefox/75.0",
    "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.10; rv:75.0) Gecko/20100101 Firefox/75.0"
  ]

  test "test user agents worker" do
    start_supervised(UserAgents)
    UserAgents.set_client(DummyClientPumba)
    UserAgents.load("Firefox")

    assert UserAgents.all() == %{
             browsers: %{
               "Firefox" => %Pumba.Result{
                 count: 5,
                 error: nil,
                 user_agents: %{
                   0 =>
                     "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:77.0) Gecko/20190101 Firefox/77.0",
                   1 =>
                     "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:77.0) Gecko/20100101 Firefox/77.0",
                   2 => "Mozilla/5.0 (X11; Linux ppc64le; rv:75.0) Gecko/20100101 Firefox/75.0",
                   3 =>
                     "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:39.0) Gecko/20100101 Firefox/75.0",
                   4 =>
                     "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.10; rv:75.0) Gecko/20100101 Firefox/75.0"
                 }
               }
             },
             client: DummyClientPumba,
             names: ["Firefox"]
           }

    assert Enum.member?(@user_agents, UserAgents.random())
  end
end

defmodule DummyClientPumba do
  def load(_) do
    {:ok,
     [
       "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:77.0) Gecko/20190101 Firefox/77.0",
       "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:77.0) Gecko/20100101 Firefox/77.0",
       "Mozilla/5.0 (X11; Linux ppc64le; rv:75.0) Gecko/20100101 Firefox/75.0",
       "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:39.0) Gecko/20100101 Firefox/75.0",
       "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.10; rv:75.0) Gecko/20100101 Firefox/75.0"
     ]}
  end
end
