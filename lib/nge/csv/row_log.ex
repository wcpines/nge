# lib/nge/csv/row_log.ex

defmodule Nge.CSV do
  defmodule RowLog do
    # TBD: Should probably drop any records missing important data
    defstruct datetime: NaiveDateTime.utc_now(),
              name: "Default Log Record",
              moving_time: 0,
              distance: 0,
              type: "Run",
              description: "No data provided"

    @type t :: %__MODULE__{}
  end
end
