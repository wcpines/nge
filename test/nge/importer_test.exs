# test/nge/importer_test.exs
defmodule Nge.ImporterTest do
  use ExUnit.Case, async: false
  alias Nge.CSV.RowLog
  import Mox

  alias Nge.Importer

  # TODO: This should probably be re-written or scrapped
  # Perhaps mocking should be used for the Strava.Activities API
  # and unit test StravaApiAdapter
  # TBD: How/whether to test the genserver

  setup do
    # https://medium.com/flatiron-labs/til-how-to-test-genservers-with-mox-eb04be3134bd
    allow(Nge.MockStravaApiAdapter, self(), Importer)
    allow(Nge.MockCSVParser, self(), Importer)
    verify_on_exit!()
  end

  describe "run/2" do
    # test "returns an error message if something fails" do
    #   expect(
    #     Nge.MockCSVParser,
    #     :parse,
    #     fn _filename ->
    #       {:ok,
    #        [
    #          %RowLog{
    #            datetime: ~N[2016-04-20T12:00:00.00],
    #            name: "A good one!",
    #            moving_time: 1620.0,
    #            distance: 6630.5,
    #            type: "Run",
    #            description: "Ppark with devo and Rich. It was beautiful"
    #          }
    #        ]}
    #     end
    #   )

    #   expect(
    #     Nge.MockStravaApiAdapter,
    #     :post_activities,
    #     fn _auth_code, _logs -> :ok end
    #   )

    #   assert Importer.run("auth_code") == :ok
    # end

    test "returns OK when successful" do
      expect(
        Nge.MockCSVParser,
        :parse,
        fn _filename ->
          {:ok,
           [
             %RowLog{
               datetime: ~N[2016-04-20T12:00:00.00],
               name: "A good one!",
               moving_time: 1620.0,
               distance: 6630.5,
               type: "Run",
               description: "Ppark with devo and Rich. It was beautiful"
             }
           ]}
        end
      )

      expect(
        Nge.MockStravaApiAdapter,
        :post_activities,
        fn _auth_code, _logs -> :ok end
      )

      assert Importer.run("auth_code") == :ok
    end
  end
end
