# lib/nge/csv/data_converter.ex
defmodule Nge.CSV.DataConverter do
  require Logger

  def fetch_datetime(log) do
    log
    |> Map.get("Date", "")
    |> NaiveDateTime.from_iso8601()
    |> case do
      {:error, _} ->
        Logger.warn("Datetime is invalid or missing:\n#{inspect(log)}")
        {:ok, NaiveDateTime.utc_now()}

      {:ok, dt} ->
        {:ok, dt}
    end
  end

  # TODO: Remove this and require CSV to be converted first?
  @spec distance_in_meters(map) :: {:ok, float} | {:error, String.t()}
  def distance_in_meters(log) do
    log
    |> Map.get("Distance", "0")
    |> Float.parse()
    |> case do
      {0.0, ""} ->
        {:ok, estimate_distance(log)}

      :error ->
        Logger.warn("Distance is invalid:\n#{inspect(log)}")
        {:error}

      {num, ""} ->
        distance =
          num
          |> Kernel.*(1609.344)
          |> Float.round(2)

        {:ok, distance}
    end
  end

  @spec total_time_to_seconds(map) :: {:ok, float}
  def total_time_to_seconds(log) do
    {min, ""} = log |> Map.get("Minutes", "0.0") |> Float.parse()
    {sec, ""} = log |> Map.get("Seconds", "0.0") |> Float.parse()

    min
    |> Kernel.*(60)
    |> Kernel.+(sec)
    |> Float.round(2)
    |> case do
      0.0 -> {:ok, estimate_time(log)}
      time -> {:ok, time}
    end
  end

  @spec estimate_time(map) :: float
  defp estimate_time(log) do
    log
    |> Map.get("Distance", "0")
    |> Float.parse()
    |> case do
      {0.0, ""} ->
        0.0

      {n, ""} ->
        Float.round(n * 60 * 7.75, 2)

      _ ->
        0.0
    end
  end

  @spec estimate_distance(map) :: float
  defp estimate_distance(log) do
    # assume every run was at least 7:45 pace, which isn't unreasonable for
    # most of my running history
    # if there is no type, distance and time both set to 0
    {:ok, seconds} = total_time_to_seconds(log)
    Float.round(seconds / 60 / 7.75, 2)
  end
end
