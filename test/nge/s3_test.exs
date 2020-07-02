# test/nge/s3_test.exs
defmodule Nge.S3Test do
  use ExUnit.Case
  alias Nge.S3

  @username "foosername"
  @csv_to_stream [
    [
      "average_speed",
      "average_watts",
      "commute",
      "distance",
      "elapsed_time",
      "id",
      "kilojoules",
      "max_speed",
      "moving_time",
      "name",
      "private",
      "start_date",
      "start_date_local",
      "timezone",
      "trainer",
      "type",
      "upload_id"
    ],
    [
      3.662,
      nil,
      false,
      3434.7,
      944,
      3_414_375_043,
      nil,
      4.6,
      938,
      "Shakeout pre Standup ",
      false,
      ~U[2020-05-07 16:54:00Z],
      ~U[2020-05-07 09:54:00Z],
      "(GMT-08:00) America/Los_Angeles",
      false,
      "Run",
      3_647_345_641
    ]
  ]

  describe "store_file/2" do
    test "it zips the file" do
      stream = @csv_to_stream |> CSV.encode()
      S3.store_file(stream, @username)
    end
  end
end
