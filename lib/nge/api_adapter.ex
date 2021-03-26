# lib/nge/api_adapter.ex
defmodule Nge.ApiAdapter do
  @callback post_activities(auth_code :: String.t(), csv_logs :: [RowLog.t()]) ::
              {:ok, String.t()} | {:error, String.t()}
  @callback fetch_activities(auth_code :: String.t()) ::
              {:ok, [Strava.SummaryActivity.t()], Tesla.Env.client()}
              | {:error, String.t()}
end
