# lib/nge/strava_api_adapter.ex

defmodule Nge.StravaApiAdapter do
  @behaviour Nge.ApiAdapter

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
    activities_to_post =
      case fetch_activities(auth_code) do
        {:ok, fetched, client} ->
          {:ok, ActivityFilter.new_activities_by_date(fetched, csv_logs), client}

        {:error, msg} ->
          {:error, msg}
      end

    case activities_to_post do
      {:ok, postable_activities, client} ->
        Enum.each(postable_activities, &post_activity(&1, client))

      {:error, msg} ->
        {:error, msg}
    end

    # TODO log errors from create_activity
    IO.inspect(activities_to_post)
    # end)
  end

  @impl true
  def fetch_activities(auth_code) do
    client = Auth.gen_client(auth_code)

    client
    |> run_count()
    |> case do
      {:ok, count} ->
        {:ok, paginated_activities(client, count), client}

      {:error, msg} ->
        {:error, msg}
    end
  end

  defp post_activity(activity, client) do
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
      # TODO: dialyzer is angry
    else
      :error ->
        {:error, "unknown run count"}
    end
  end
end
