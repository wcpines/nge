# test/nge/csv/parser_test.exs

defmodule Nge.CSV.ParserTest do
  use ExUnit.Case
  alias Nge.CSV.Parser
  alias Nge.CSV.RowLog

  @invalid_input_file "invalid.tsv"
  @valid_input_file File.cwd!() <> "/test/support/test.csv"

  describe "CSV.Parser.parse/1" do
    test "when given an invalid file" do
      assert Parser.parse(@invalid_input_file) ==
               {:error, "Provided filename does not reference a valid CSV"}
    end

    test "when given a valid csv and some rows are missing data" do
      assert Parser.parse(@valid_input_file) ==
               {:ok,
                [
                  %RowLog{
                    datetime: ~N[2016-04-20T12:00:00.00],
                    name: "A good one!",
                    moving_time: 1620.0,
                    distance: 6630.5,
                    type: "Run",
                    description: "Ppark with devo and Rich. It was beautiful"
                  },
                  %Nge.CSV.RowLog{
                    datetime: ~N[2016-04-21 12:00:00.00],
                    description: "Fake record missing data",
                    distance: 0.0,
                    moving_time: 0.0,
                    name: "A baad one!",
                    type: "Run"
                  }
                ]}
    end
  end
end
