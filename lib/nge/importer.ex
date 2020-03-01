# lib/nge/importer.ex

defmodule Nge.Importer do
  def run do
    case ActivityLogParser.parse(@csv) do
      {:ok, logs} -> Api.post_runs(logs)
      {:error, msg} -> IO.puts(msg)
      _ -> IO.puts("borked")
    end
  end
end
