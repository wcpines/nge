# lib/nge/exporter.ex

defmodule Nge.Exporter do
  alias Nge.CSVParser
  alias Nge.Api

  require Logger
  use GenServer

  def run(auth_code, strava_activities) do
    GenServer.call(__MODULE__, {:run, auth_code, strava_activities})
  end

  def handle_call({:run, auth_code, strava_activities}, _from, _empty_map) do
    case CSVGenerator.generate(strava_activities) do
      {:ok, csv} ->
        Logger.info("CSV Successfully generated, preparing to email!")

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
