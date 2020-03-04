# lib/nge/importer.ex

defmodule Nge.Importer do
  alias Nge.ActivityLogParser
  alias Nge.Api

  require Logger
  use GenServer
  @csv Application.get_env(:nge, :activity_log)

  def run(auth_code, csv \\ @csv) do
    GenServer.call(__MODULE__, {:run, auth_code, csv})
  end

  def handle_call({:run, auth_code, csv}, _from, _empty_map) do
    case ActivityLogParser.parse(csv) do
      {:ok, logs} ->
        Logger.info("CSV Successfully parsed, posting to Strava!")
        Api.post_runs(auth_code, logs)

      {:error, msg} ->
        long_message = """
        An error occurred while trying to parse your running logs:\n
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
