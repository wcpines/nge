# test/nge/importer_test.exs
defmodule Nge.ImporterTest do
  use ExUnit.Case, async: true
  alias Nge.CSV.RowLog
  import Mox

  alias Nge.Importer

  setup do
    # https://medium.com/flatiron-labs/til-how-to-test-genservers-with-mox-eb04be3134bd
    allow(Nge.MockStravaApiAdapter, self(), Importer)
    allow(Nge.MockCSVParser, self(), Importer)
    verify_on_exit!()
  end

  test "it starts" do
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
