# lib/nge/importer.ex

defmodule Nge.Importer do
  alias Nge.ActivityLogParser
  alias Nge.Api

  use GenServer
  @csv Application.get_env(:nge, :activity_log)

  def run(auth_code, csv \\ @csv) do
    GenServer.call(__MODULE__, {:run, auth_code, csv})
  end

  def handle_call({:run, csv, code}, _from, _empty_map) do
    case ActivityLogParser.parse(csv) do
      {:ok, logs} -> Api.post_runs(logs, code)
      {:error, msg} -> IO.puts(msg)
      _ -> IO.puts("borked")
    end
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_opts) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end
end
