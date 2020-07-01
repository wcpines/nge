# lib/nge/csv_generator.ex
defmodule Nge.CSVGenerator do
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

  @spec generate_csv_stream([%Strava.SummaryActivity{}]) :: {:ok, list() | :error, String.t()}
  def generate_csv_stream([%Strava.SummaryActivity{} | _t] = strava_activities) do
    result =
      strava_activities
      |> extract_fields()
      |> fields_to_rows()
      |> CSV.encode()
      |> Enum.to_list()

    case result do
      result when is_list(result) -> {:ok, result}
      _ -> generic_convert_error()
    end
  end

  def generate_csv_stream(_other_inputs), do: generic_convert_error()

  ##### helpers #####

  @spec extract_fields([%Strava.SummaryActivity{}]) :: [map()]
  defp extract_fields(strava_activities) do
    Enum.map(strava_activities, fn activity ->
      Map.take(activity, @default_columns)
    end)
  end

  @spec fields_to_rows([map()]) :: [list()]
  defp fields_to_rows(activities) do
    headers = get_headers(activities)
    rows = Enum.map(activities, &Map.values/1)

    [headers | rows]
  end

  defp get_headers(activities) do
    activities
    |> List.first()
    |> Map.keys()
    |> Enum.map(&Atom.to_string/1)
  end

  defp generic_convert_error, do: {:error, "Could not convert strava activities to csv"}
end
