# lib/nge/auth.ex
defmodule Auth do
  alias Strava.Auth, as: Api

  def gen_client do
    code = get_code |> String.trim()

    Api.get_token(code: code, grant_type: "authorization_code")
    |> elem(1)
    |> Map.get(:token)
    |> Map.get(:access_token)
    |> Strava.Client.new()
  end

  def get_url do
    Api.authorize_url!(
      scope: "profile:write,activity:read_all,activity:write",
      response_type: "code"
    )
  end

  def get_code do
    url = get_url
    IO.puts("Open the url and copy/paste the code param once you approve")
    IO.puts(url)

    IO.gets("What is the code\n")
  end
end
