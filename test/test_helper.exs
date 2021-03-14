ExUnit.start()
Application.put_env(:tesla, Pumba.Client.DefaultClient, adapter: Tesla.Mock)
