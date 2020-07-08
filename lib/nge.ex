defmodule Nge do
  use Application
  require Logger
  alias Nge.Importer
  alias Nge.Exporter
  alias Nge.Router

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: 4000]},
      {Exporter, []},
      {Importer, []}
    ]

    Logger.info("Starting application...")

    Supervisor.start_link(children, strategy: :one_for_one, name: Nge.Supervisor)
  end
end
