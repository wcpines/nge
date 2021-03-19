# lib/nge/exporter.ex

defmodule Nge.Exporter do
  alias Nge.CSV.Generator
  alias Nge.StravaApiAdapter

  require Logger
  use GenServer

  def run(auth_code, strava_activities) do
    GenServer.call(__MODULE__, {:run, auth_code, strava_activities})
  end

  def handle_call({:run, auth_code}, _from, _empty_map) do
    {:ok, strava_activities, _client} = StravaApiAdapter.fetch_activities(auth_code)

    reply =
      case Generator.generate_csv_stream(strava_activities) do
        {:error, msg} ->
          msg

        # TODO: dialyzer is angry
        _csv_stream ->
          Logger.info("CSV Successfully generated, preparing to email!")
          "TODO: s3 upload"
      end

    {:reply, reply, %{}}
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_opts) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end
end
