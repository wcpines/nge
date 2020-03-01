# lib/nge/router.ex

defmodule Nge.Router do
  use Plug.Router

  import Plug.Conn

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    accept: ["application/json", "text/*"],
    json_decoder: Jason
  )

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http(__MODULE__, [])
  end
end
