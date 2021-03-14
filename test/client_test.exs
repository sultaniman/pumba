defmodule ClientTest do
  @moduledoc false
  use ExUnit.Case
  import Tesla.Mock

  @sample_response """
  <div id="liste">
    <h2>Firefox User Agent Strings</h2>
    <h3><img src="/img//browser/firefox.png" alt="Firefox" class="uaIcon">Firefox</h3><br><em>Click on any string to get more details</em><br>
    <h4>Firefox 77.0</h4>
    <ul>
      <li><a href="/index.php?id=19948">Mozilla/5.0 (Windows NT 6.1; WOW64; rv:77.0) Gecko/20190101 Firefox/77.0</a></li>
      <li><a href="/index.php?id=19961">Mozilla/5.0 (Windows NT 10.0; WOW64; rv:77.0) Gecko/20100101 Firefox/77.0</a></li>
    </ul>
    <h4>Firefox 75.0</h4>
    <ul>
      <li><a href="/index.php?id=19957">Mozilla/5.0 (X11; Linux ppc64le; rv:75.0) Gecko/20100101 Firefox/75.0</a></li>
      <li><a href="/index.php?id=19956">Mozilla/5.0 (Windows NT 6.1; WOW64; rv:39.0) Gecko/20100101 Firefox/75.0</a></li>
      <li><a href="/index.php?id=19949">Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.10; rv:75.0) Gecko/20100101 Firefox/75.0</a></li>
    </ul>
  </div>
  """

  @expected_result {
    :ok,
    [
      "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:77.0) Gecko/20190101 Firefox/77.0",
      "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:77.0) Gecko/20100101 Firefox/77.0",
      "Mozilla/5.0 (X11; Linux ppc64le; rv:75.0) Gecko/20100101 Firefox/75.0",
      "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:39.0) Gecko/20100101 Firefox/75.0",
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.10; rv:75.0) Gecko/20100101 Firefox/75.0"
    ]
  }

  setup do
    mock(fn _env ->
      %Tesla.Env{status: 200, body: @sample_response}
    end)

    :ok
  end

  test "default client parses response properly" do
    assert Pumba.Client.DefaultClient.load("Firefox") == @expected_result
  end
end
