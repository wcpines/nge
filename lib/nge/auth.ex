# lib/nge/auth.ex
defmodule Nge.Auth do
  alias Strava.Auth, as: Strauth

  def gen_client(code) do
    Strauth.get_token(code: code, grant_type: "authorization_code")
    |> elem(1)
    |> Map.get(:token)
    |> Map.get(:access_token)
    |> Strava.Client.new()
  end

  def get_url do
    Strauth.authorize_url!(
      scope: "profile:write,activity:read_all,activity:write",
      response_type: "code"
    )
  end
end
