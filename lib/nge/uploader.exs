defmodule Uploader do
  def login do
    Strava.Auth.authorize_url!(
      scope: "profile:write,activity:read_all,activity:write",
      response_type: "code"
    )

    client = Strava.Client.new("[code]")
  end

  def get_runs do
    Strava.Paginator.stream(fn paginator ->
      Strava.Activities.get_logged_in_athlete_activities(client, paginator)
    end)
    |> Stream.take(1000)
    |> Enum.filter(&(Map.get(&1, :type) == "Run"))
  end

  def get_skip_dates(runs) do
    Enum.map(runs, fn run ->
      Map.get(run, :start_date)
      |> DateTime.to_date()
      |> Date.to_iso8601()
    end)
  end
end
