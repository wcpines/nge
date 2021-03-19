# lib/nge/importer.ex

defmodule Nge.Importer do
  alias Nge.CSV.Parser

  require Logger
  use GenServer
  @csv_filename Application.get_env(:nge, :activity_log)
  @api Application.get_env(:nge, :strava_api_adapter)

  @spec run(atom | pid, String.t(), String.t()) :: any
  def run(server \\ __MODULE__, auth_code, csv_filename \\ @csv_filename) do
    IO.puts(auth_code)
    GenServer.call(server, {:run, auth_code, csv_filename})
  end

  def handle_call({:run, auth_code, csv_filename}, _from, _empty_map) do
    reply =
      case Parser.parse(csv_filename) do
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

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(opts \\ [name: __MODULE__]) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], opts)
  end
end
