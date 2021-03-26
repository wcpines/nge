# lib/nge/importer.ex

defmodule Nge.Importer do
  require Logger
  use GenServer

  @api Application.get_env(:nge, :strava_api_adapter)
  @parser Application.get_env(:nge, :csv_parser)
  @csv_filename Application.get_env(:nge, :activity_log)

  # Client

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec run(String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def run(auth_code, csv_filename \\ @csv_filename) do
    GenServer.call(__MODULE__, {:run, auth_code, csv_filename})
  end

  # Server
  def init(_init_arg) do
    {:ok, []}
  end

  def handle_call({:run, auth_code, csv_filename}, _from, _empty_map) do
    reply =
      case @parser.parse(csv_filename) do
        {:ok, logs} ->
          Logger.info("CSV Successfully parsed, posting to Strava!")
          @api.post_activities(auth_code, logs)

        {:error, msg} ->
          long_message = """
          An error occurred while trying to parse your running logs:\n
          Reason:
          #{msg}
          """

          {:error, long_message}
      end

    {:reply, reply, %{}}
  end
end
