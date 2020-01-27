# test/nge/log_parser_test.exs
defmodule LogParserTest do
  use ExUnit.Case

  alias LogParser
  @invalid_input_file "invalid.tsv"
  @valid_input_file File.cwd!() <> "/test/support/test.csv"

  describe "LogParser.parse/1" do
    test "when given an invalid file" do
      assert LogParser.parse(@invalid_input_file) == {:error, "Please provide a valid CSV"}
    end

    test "when given a valid csv" do
      assert LogParser.parse(@valid_input_file) ==
               {:ok,
                [
                  %{
                    datetime: ~N[2016-04-20T12:00:00.00],
                    name: "A good one!",
                    moving_time: 1620.0,
                    distance: 6630.5,
                    type: "Run",
                    description: "Ppark with devo and Rich. It was beautiful"
                  }
                ]}
    end
  end
end
