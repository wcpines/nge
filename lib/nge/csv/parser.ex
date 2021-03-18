# lib/nge/csv/parser.ex

defmodule Nge.CSV.Parser do
  alias Nge.CSV.DataConverter
  alias Nge.CSV.RowLog
  alias CSV
  require Logger

  @moduledoc """
  Parses a given CSV provided through web UI
    - cursory check of filetype
    - validates format of each row (else returns error tuple)
    - removes blank records and empty columns
    - reformats/converts each record into map for strava upload
  """

  # TODO require CSV format that doesn't need data converter?

  @spec parse(String.t()) ::
          {:ok, [RowLog.t()]} | {:error, String.t()}
  def parse(csv_filename) do
    if valid_file?(csv_filename) do
      csv_filename
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> check_and_format()
    else
      {:error, "Provided filename does not reference a valid CSV"}
    end
  end

  defp check_and_format(parsed_csv_stream) do
    if Enum.any?(parsed_csv_stream, &match?({:error, _error_message}, &1)) do
      {:error, "Please clean your csv file"}
    else
      set =
        Enum.map(
          parsed_csv_stream,
          fn row ->
            {:ok, row_data} = row

            row_data
            |> find_empty_records()
            |> decunstruct_map()
          end
        )

      {:ok, set}
    end
  end

  defp valid_file?(file) do
    Path.extname(file) == ".csv" && File.exists?(file)
  end

  defp find_empty_records(row_data) do
    missing_columns_removed =
      row_data
      |> Enum.reject(fn {_x, y} ->
        y == ""
      end)
      |> Map.new()

    if missing_columns_removed == %{} do
      Logger.warn("Found blank record: #{inspect(row_data)}")
      %{}
    else
      missing_columns_removed
    end
  end

  # discard empty records
  defp decunstruct_map(row_data) when map_size(row_data) == 0, do: %{}

  defp decunstruct_map(%{"is_xt" => "TRUE"}), do: %{}

  defp decunstruct_map(row_data) do
    with {:ok, datetime} <- DataConverter.fetch_datetime(row_data),
         {:ok, total_meters} <- DataConverter.distance_in_meters(row_data),
         {:ok, total_seconds} <- DataConverter.total_time_to_seconds(row_data),
         name <- Map.get(row_data, "Name"),
         notes <- Map.get(row_data, "Notes") do
      struct(
        RowLog,
        %{
          datetime: datetime,
          name: name,
          moving_time: total_seconds,
          distance: total_meters,
          type: "Run",
          description: notes
        }
      )
    end
  end
end
