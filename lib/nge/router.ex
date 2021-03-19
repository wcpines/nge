# lib/nge/router.ex

defmodule Nge.Router do
  use Plug.Router
  import Plug.Conn

  alias Nge.Importer
  alias Nge.Auth

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    accept: ["application/json", "text/*"],
    json_decoder: Jason
  )

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> send_file(200, "lib/nge/templates/index.eex")
  end

  post "/login" do
    url = Auth.get_url()

    body =
      "<html><body>You are being <a href=\"#{Plug.HTML.html_escape(url)}\">redirected</a>.</body></html>"

    conn
    |> put_resp_header("location", url)
    |> send_resp(conn.status || 302, body)
  end

  get "/import" do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> send_file(200, "lib/nge/templates/import.eex")
  end

  post "/import" do
    conn
    |> get_code_from_header()
    |> Importer.run()
  end

  match _ do
    send_resp(
      conn,
      404,
      "sorry, nothin here"
    )
  end

  @spec get_code_from_header(%Plug.Conn{}) :: String.t()
  defp get_code_from_header(conn) do
    conn
    |> get_req_header("referer")
    |> List.first()
    |> String.split("code=")
    |> Enum.at(1)
    |> String.split("&")
    |> List.first()
  end
end
