# lib/nge/api.ex
defmodule Nge.Api do
  alias Nge.Auth
  alias Nge.ActivityFilter

  @moduledoc """
  Fetching auth'd athlete activities
  Posting new ones
  """
  @default_activity_type "Run"

  # selectively post *new* activities
  def post_activities(auth_code, csv_logs) do
    activities_to_post =
      case fetch_activities(auth_code) do
        {:ok, fetched} ->
          {:ok, ActivityFilter.new_activities_by_date(fetched, csv_logs)}

        {:error, msg} ->
          {:error, msg}
      end

    IO.inspect(activities_to_post)
    # |> Enum.each(fn run ->
    #   Strava.Activities.create_activity(
    #     client,
    #     run.name,
    #     run.type,
    #     run.datetime,
    #     run.moving_time,
    #     distance: run.distance
    #   )
    # end)
  end

  def fetch_activities(auth_code) do
    client = Auth.gen_client(auth_code)

    client
    |> run_count()
    |> case do
      {:ok, count} ->
        {:ok, paginated_activities(client, count)}

      {:error, msg} ->
        {:error, msg}
    end
  end

  defp paginated_activities(client, count, activity_type \\ @default_activity_type) do
    Strava.Paginator.stream(fn paginator ->
      Strava.Activities.get_logged_in_athlete_activities(client, paginator)
    end)
    |> Stream.take(count)
    |> Enum.filter(&(Map.get(&1, :type) == activity_type))
  end

  # determine the number of running activities completed by the athlete so
  # we are able to fetch that amount
  defp run_count(client) do
    with client,
         {:ok, athlete} <- Strava.Athletes.get_logged_in_athlete(client),
         {:ok, id} <- Map.fetch(athlete, :id),
         {:ok, stats} <- Strava.Athletes.get_stats(client, id) do
      {:ok, stats.all_run_totals.count}
    else
      :error ->
        {:error, "unknown run count"}
    end
  end
end
