# test/nge/s3_test.exs
defmodule Nge.S3Test do
  use ExUnit.Case
  alias Nge.S3

  @email_address "foo@bar.com"
  @csv_string """
  average_speed,average_watts,commute,distance,elapsed_time,id,kilojoules,max_speed,moving_time,name,private,start_date,start_date_local,timezone,trainer,type,upload_id
  3.662,,false,3434.7,944,3414375043,,4.6,938,Shakeout pre Standup ,false,2020-05-07 16:54:00Z,2020-05-07 09:54:00Z,(GMT-08:00) America/Los_Angeles,false,Run,3647345641
  """

  describe "store_file/2" do
    @tag :pending
    test "it zips the file" do
      IO.puts("pending")
      # S3.store_file(@csv_string, @email_address)
    end
  end
end
