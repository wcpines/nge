# lib/nge/router.ex

defmodule Nge.Router do
  use Plug.Router
  import Plug.Conn

  alias Nge.Importer
  alias Nge.Exporter
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

  get "/import_export" do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> send_file(200, "lib/nge/templates/import_export.eex")
  end

  post "/import" do
    code =
      conn
      |> get_req_header("referer")
      |> get_auth_code()

    Importer.run(code)
  end

  post "/export" do
    code =
      conn
      |> get_req_header("referer")
      |> get_auth_code()

    case get_email_address(conn) do
      {:ok, email} ->
        case Exporter.run(code, email) do
          {:ok, s3_location} ->
            "email_user"

          {:error, msg} ->
            send_resp(conn, 400, msg)
        end

      {:error, _msg} ->
        send_resp(conn, 400, "bad input: email")
    end
  end

  match _ do
    send_resp(
      conn,
      404,
      "sorry, nothin here"
    )
  end

  def get_auth_code(referer) do
    referer
    |> List.first()
    |> String.split("code=")
    |> Enum.at(1)
    |> String.split("&")
    |> List.first()
  end

  def get_email_address(conn) do
    with {:ok, email_map} <- Map.fetch(conn, :body_params),
         {:ok, email} <- Map.fetch(email_map, "email_address") do
      {:ok, email}
    else
      :error ->
        {:error, "email not found or invalid"}
    end
  end
end
