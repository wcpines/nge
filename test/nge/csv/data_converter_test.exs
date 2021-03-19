# test/nge/csv/data_converter_test.exs
defmodule Nge.CSV.DataConverterTest do
  use ExUnit.Case
  alias Nge.CSV.DataConverter

  @row_data %{
    "" => ["", "", "", "", "", "", "", "", ""],
    "Date" => "2016-04-20T12:00:00.00",
    "Distance" => "4.12",
    "Mile Pace" => "6.77",
    "Minutes" => "27",
    "Name" => "A good one!",
    "Notes" => "Ppark with devo and Rich. It was beautiful",
    "Shoes" => "Altra torin 2.0 torin"
  }

  describe "Data Conversion Functions" do
    test "fetch_datetime/1 with present value" do
      assert DataConverter.fetch_datetime(@row_data) == {:ok, ~N[2016-04-20 12:00:00.00]}
    end

    test "fetch_datetime/1 with missing value" do
      {:ok, dt} =
        @row_data
        |> Map.delete("Date")
        |> DataConverter.fetch_datetime()

      assert is_binary(NaiveDateTime.to_iso8601(dt))
    end

    test "distance_in_meters/1 with present value" do
      assert DataConverter.distance_in_meters(@row_data) == {:ok, 6630.5}
    end

    test "distance_in_meters/1 with missing distance but present time" do
      {:ok, distance_estimate} =
        @row_data
        |> Map.delete("Distance")
        |> DataConverter.distance_in_meters()

      assert distance_estimate == 3.48
    end

    test "distance_in_meters/1 with missing distance and time" do
      {:ok, distance_estimate} =
        @row_data
        |> Map.drop(["Distance", "Minutes", "Seconds"])
        |> DataConverter.distance_in_meters()

      assert distance_estimate == 0.0
    end

    test "total_time_to_seconds/1" do
      assert DataConverter.total_time_to_seconds(@row_data) == {:ok, 1620.0}
    end

    test "total_time_to_seconds/1 with missing time but present distant" do
      {:ok, time_estimate} =
        @row_data
        |> Map.drop(["Seconds", "Minutes"])
        |> DataConverter.total_time_to_seconds()

      assert time_estimate == 1915.8
    end

    test "total_time_to_seconds/1 with missing distance and time" do
      {:ok, time_estimate} =
        @row_data
        |> Map.drop(["Distance", "Minutes", "Seconds"])
        |> DataConverter.total_time_to_seconds()

      assert time_estimate == 0.0
    end
  end
end
