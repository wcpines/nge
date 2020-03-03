# lib/nge/log_filter.ex
defmodule Nge.ActivityLogFilter do
  def new_activities_by_date(strava_logs, new_logs) do
    strava_logs
    |> filterable_dates
    |> filter_duplicates(new_logs)
  end

  def filter_duplicates(filter_dates, new_logs) do
    for log <- new_logs,
        log != %{},
        NaiveDateTime.to_date(log.datetime) not in filter_dates,
        do: log
  end

  def filterable_dates(strava_logs) do
    strava_logs
    |> Enum.map(&DateTime.to_date(&1.start_date_local))
  end
end
