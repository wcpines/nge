defmodule Nge do
  alias LogParser
  alias Api

  @csv Application.get_env(:nge, :activity_log)

  def run do
    case LogParser.parse(@csv) do
      {:ok, logs} -> Api.post_runs(logs)
      {:error, msg} -> IO.puts(msg)
      _ -> IO.puts("borked")
    end
  end
end
