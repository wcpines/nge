# lib/nge/csv/generator.ex

defmodule Nge.CSV.Generator do
  alias CSV
  require Logger

  @default_columns [
    :average_speed,
    :average_watts,
    :commute,
    :distance,
    :elapsed_time,
    :id,
    :kilojoules,
    :max_speed,
    :moving_time,
    :name,
    :private,
    :start_date,
    :start_date_local,
    :timezone,
    :trainer,
    :type,
    :upload_id
  ]

  @spec generate_csv_stream([Strava.SummaryActivity.t()]) :: {:ok, fun()} | {:error, String.t()}
  def generate_csv_stream(strava_activities) do
    # TBD: is this the right pattern?  Feels bad...
    try do
      strava_activities
      |> extract_data()
      |> rows_with_headers()
      |> CSV.encode()
    rescue
      e -> {:error, "Something went wrong parsing strava activities: #{inspect(e)}"}
    end
  end

  @spec extract_data([%Strava.SummaryActivity{}]) :: [map()]
  defp extract_data(strava_activities) do
    Enum.map(strava_activities, fn activity ->
      Map.take(activity, @default_columns)
    end)
  end

  @spec rows_with_headers([map()]) :: [list()]
  defp rows_with_headers(activities) do
    headers =
      activities
      |> List.first()
      |> Map.keys()
      |> Enum.map(&Atom.to_string/1)

    rows = Enum.map(activities, &Map.values/1)

    [headers | rows]
  end
end
