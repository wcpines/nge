# lib/nge/auth.ex
defmodule Nge.Auth do
  @spec gen_client(String.t()) :: Tesla.Env.client()
  def gen_client(code) do
    Strava.Auth.get_token(code: code, grant_type: "authorization_code")
    |> elem(1)
    |> Map.get(:token)
    |> Map.get(:access_token)
    |> Strava.Client.new()
  end

  @spec get_url :: binary
  def get_url do
    Strava.Auth.authorize_url!(
      scope: "profile:write,activity:read_all,activity:write",
      response_type: "code"
    )
  end
end
