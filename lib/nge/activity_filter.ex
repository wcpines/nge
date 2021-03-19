# lib/nge/log_filter.ex

defmodule Nge.ActivityFilter do
  @spec new_activities_by_date([Strava.SummaryActivity.t()], [RowLog.t()]) :: [RowLog.t()]
  def new_activities_by_date(strava_logs, csv_logs) do
    strava_logs
    |> filterable_dates
    |> filter_duplicates(csv_logs)
  end

  @spec filter_duplicates([DateTime.t()], [RowLog.t()]) :: [RowLog.t()]
  def filter_duplicates(filter_dates, csv_logs) do
    for log <- csv_logs,
        log != %{},
        NaiveDateTime.to_date(log.datetime) not in filter_dates,
        do: log
  end

  @spec filterable_dates([Strava.SummaryActivity.t()]) :: [DateTime.t()]
  def filterable_dates(strava_logs) do
    strava_logs
    |> Enum.map(&DateTime.to_date(&1.start_date_local))
  end
end
