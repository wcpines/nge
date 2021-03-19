# lib/nge/api_adapter.ex
defmodule Nge.ApiAdapter do
  @callback post_activities(String.t(), [map()]) :: :ok
  @callback fetch_activities(String.t()) ::
              {:ok, [Strava.SummaryActivity.t()], Tesla.Env.client()}
              | {:error, String.t()}
end
