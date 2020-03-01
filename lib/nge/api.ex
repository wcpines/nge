# lib/nge/api.ex
defmodule Api do
  @moduledoc """
  Fetching auth'd athlete activities
  Posting new ones
  """
  @default_activity_type "Run"

  alias Auth

  def post_runs(csv_logs) do
    client = Auth.gen_client()

    new =
      client
      |> fetch_runs
      |> LogFilter.new_activities_by_date(csv_logs)

    require IEx; IEx.pry
    new
    |> Enum.each(fn run ->
      Strava.Activities.create_activity(
        client,
        run.name,
        run.type,
        run.datetime,
        run.moving_time,
        distance: run.distance
      )
    end)
  end

  def fetch_runs(client) do
    paginated_activities(client)
  end

  def paginated_activities(client, activity_type \\ @default_activity_type) do
    Strava.Paginator.stream(fn paginator ->
      Strava.Activities.get_logged_in_athlete_activities(client, paginator)
    end)
    |> Stream.take(5000)
    |> Enum.filter(&(Map.get(&1, :type) == activity_type))
  end
end
