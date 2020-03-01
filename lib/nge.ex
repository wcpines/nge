defmodule Nge do
  alias Nge.ActivityLogParser
  alias Nge.Api

  @csv Application.get_env(:nge, :activity_log)

  def start do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Nge.Plug, options: [port: 4001]}
    ]

    opts = [strategy: :one_for_one, name: Nge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run do
    case ActivityLogParser.parse(@csv) do
      {:ok, logs} -> Api.post_runs(logs)
      {:error, msg} -> IO.puts(msg)
      _ -> IO.puts("borked")
    end
  end
end
