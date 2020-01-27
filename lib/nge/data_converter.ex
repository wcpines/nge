# lib/nge/data_converter.ex
defmodule DataConverter do
  def fetch_datetime(log) do
    log
    |> Map.get("Date", "")
    |> NaiveDateTime.from_iso8601()
    |> case do
      {:error, _} ->
        {:error, "Date is invalid"}
        IO.inspect(log)

      {:ok, dt} ->
        {:ok, dt}
    end
  end

  def distance_in_meters(log) do
    log
    |> Map.get("Distance", "0")
    |> Float.parse()
    |> case do
      {0.0, ""} ->
        {:ok, estimate_distance(log)}

      :error ->
        IO.inspect(log)
        {:error, "Distance is invalid"}

      {num, ""} ->
        distance =
          num
          |> Kernel.*(1609.344)
          |> Float.round(2)

        {:ok, distance}
    end
  end

  def total_time_to_seconds(log) do
    {min, ""} = log |> Map.get("Minutes", "0.0") |> Float.parse()
    {sec, ""} = log |> Map.get("Seconds", "0.0") |> Float.parse()

    min
    |> Kernel.*(60)
    |> Kernel.+(sec)
    |> Float.round(2)
    |> case do
      0.0 ->
        {:ok, estimate_time(log)}

      time ->
        {:ok, time}
    end
  end

  def estimate_time(log) do
    log
    |> Map.get("Distance", "0")
    |> Float.parse()
    |> case do
      {0.0, ""} ->
        0.0

      {n, ""} ->
        n * 7.75

      _ ->
        0.0
    end
  end

  def estimate_distance(log) do
    case total_time_to_seconds(log) do
      {:ok, time} ->
        time / 60 / 7.75

      _ ->
        {:error, "No distance or time info"}
    end
  end
end
