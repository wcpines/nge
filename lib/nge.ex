defmodule Nge do
  alias Nge.ActivityLogParser
  alias Nge.Api

  @csv Application.get_env(:nge, :activity_log)

  def start do
    children = [
      worker(Nge.Router, []),
      worker(Nge.Importer, [])
    ]

    opts = [strategy: :one_for_one, name: Nge.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
