# lib/nge/api.ex
defmodule Nge.Api do
  alias Nge.Auth
  alias Nge.ActivityLogFilter

  @moduledoc """
  Fetching auth'd athlete activities
  Posting new ones
  """
  @default_activity_type "Run"

  # scope: all
  # scope: after: (epoch)
  # scope: before: (epoch)

  # def post_runs(auth_code, csv_logs, scope) do
  def post_runs(auth_code, csv_logs) do
    client = Auth.gen_client(auth_code)

    activities_to_post =
      case run_count(client) do
        {:ok, count} ->
          new = paginated_activities(client, count)
          require IEx
          IEx.pry()
          {:ok, ActivityLogFilter.new_activities_by_date(new, csv_logs)}

        {:error, msg} ->
          {:error, msg}
      end

    activities_to_post
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

  def paginated_activities(client, count, activity_type \\ @default_activity_type) do
    Strava.Paginator.stream(fn paginator ->
      Strava.Activities.get_logged_in_athlete_activities(client, paginator)
    end)
    |> Stream.take(count)
    |> Enum.filter(&(Map.get(&1, :type) == activity_type))
  end

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
