# lib/nge/csv_parser.ex

defmodule Nge.CSVParser do
  alias Nge.DataConverter
  alias CSV
  require Logger

  @spec parse(String.t()) :: {:ok, [ok: map()]} | {:error, String.t()}
  def parse(csv_filename) do
    csv_filename
    |> valid_file?
    |> case do
      true ->
        do_parse(csv_filename)

      false ->
        {:error, "Please provide a valid CSV"}
    end
  end

  # TODO how to loop through all, not 'take'
  def do_parse(csv_filename) do
    parsed_logs =
      csv_filename
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> Enum.take(10000)

    parsed_logs
    |> Enum.any?(&match?({:error, _error_message}, &1))
    |> case do
      true ->
        {:error, "Please clean your csv file"}

      false ->
        format(parsed_logs)
    end
  end

  @spec format(ok: map()) :: {:ok, [map()]} | {:error, String.t()}
  defp format(results) do
    set =
      Enum.map(
        results,
        fn log_tuple ->
          {:ok, log} = log_tuple

          log
          |> remove_blanks()
          |> decunstruct_map()
        end
      )

    {:ok, set}
  end

  defp valid_file?(file) do
    Path.extname(file) == ".csv" && File.exists?(file)
  end

  defp remove_blanks(log) do
    original = log

    cleaned =
      original
      |> Enum.reject(fn {_x, y} -> y == "" end)
      |> Map.new()

    if cleaned == %{} do
      {cleaned, original}
    else
      cleaned
    end
  end

  defp decunstruct_map({new, old}) do
    Logger.warn("debug")
    Logger.debug(inspect(new))
    Logger.debug(inspect(old))
  end

  defp decunstruct_map(%{"is_xt" => "TRUE"}), do: %{}

  defp decunstruct_map(log) do
    with {:ok, datetime} <- DataConverter.fetch_datetime(log),
         {:ok, total_meters} <- DataConverter.distance_in_meters(log),
         {:ok, total_seconds} <- DataConverter.total_time_to_seconds(log),
         name <- Map.get(log, "Name", "Backfilled run"),
         notes <- Map.get(log, "Notes", "") do
      %{
        datetime: datetime,
        name: name,
        moving_time: total_seconds,
        distance: total_meters,
        type: "Run",
        description: notes
      }
    else
      {:error, msg} ->
        Logger.warn(msg)
    end
  end
end
