# lib/nge/strava_api_adapter.ex

defmodule Nge.StravaApiAdapter do
  @behaviour Nge.ApiAdapter
  @live Application.get_env(:nge, :really_post_logs)

  alias Nge.Auth
  alias Nge.ActivityFilter

  require Logger

  @moduledoc """
  Fetching auth'd athlete activities
  Posting new ones
  """
  @default_activity_type "Run"

  # selectively post *new* activities
  @impl true
  def post_activities(auth_code, csv_logs) do
    with {:ok, fetched, client} <- fetch_activities(auth_code),
         postable_activities <- ActivityFilter.new_activities_by_date(fetched, csv_logs),
         posted <- Enum.map(postable_activities, &post_activity(&1, client)) do
      failed_count = Enum.count(posted, &({:error, _} = &1))
      success_count = length(posted) - failed_count

      {:ok, "Successfully posted #{success_count} activities; #{failed_count} failed to upload"}
    else
      {:error, msg} ->
        {:error, msg}
    end
  end

  @impl true
  def fetch_activities(auth_code) do
    client = Auth.gen_client(auth_code)

    case run_count(client) do
      {:ok, count} ->
        {:ok, paginated_activities(client, count), client}

      {:error, msg} ->
        {:error, msg}
    end
  end

  defp post_activity(activity, client) do
    if @live do
      res =
        Strava.Activities.create_activity(
          client,
          activity.name,
          activity.type,
          activity.datetime,
          activity.moving_time,
          distance: activity.distance
        )

      case res do
        {:error, tesla_env} ->
          Logger.warn("Activity failed to upload",
            activity: activity,
            api_response_body: tesla_env.body
          )

          res

        _ ->
          res
      end
    else
      Logger.info("Not live, ignoring logs to post")
      {:ok, "not live"}
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
      {:error, tesla_env} ->
        log_strava_error(tesla_env)
        {:error, "unknown run count"}

      :error ->
        {:error, "athlete ID not found"}
    end
  end

  defp log_strava_error(tesla_env) do
    Logger.error("""
    request to strava failed
    status: #{tesla_env.status}
    body: #{tesla_env.body}
    """)
  end
end
