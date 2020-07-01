# lib/nge/exporter.ex

defmodule Nge.Exporter do
  alias Nge.CSVGenerator
  alias Nge.Api

  require Logger
  use GenServer

  def run(auth_code, strava_activities) do
    GenServer.call(__MODULE__, {:run, auth_code, strava_activities})
  end

  def handle_call({:run, auth_code}, _from, _empty_map) do
    strava_activities = Api.fetch_activities(auth_code)

    case CSVGenerator.generate_csv_stream(strava_activities) do
      {:ok, csv} ->
        Logger.info("CSV Successfully generated, preparing to email!")
        IO.inspect(csv)

      {:error, msg} ->
        long_message = """
        An error occurred while trying to generate a csv of your Strava activities:\n
        Reason:
        #{msg}
        """

        {:error, long_message}

      _ ->
        Logger.error("A misc. error occurred")
        {:error, "borked"}
    end
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_opts) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end
end
