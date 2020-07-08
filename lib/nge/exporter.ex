# lib/nge/exporter.ex

defmodule Nge.Exporter do
  alias Nge.Api
  alias Nge.CSVGenerator
  alias Nge.S3

  require Logger
  use GenServer

  def run(auth_code, email_address) do
    GenServer.call(__MODULE__, {:run, auth_code, email_address}, :infinity)
  end

  def handle_call({:run, auth_code, email_address}, _from, _empty_map) do
    auth_code
    |> Api.fetch_activities()
    |> CSVGenerator.generate_csv_stream()
    |> case do
      {:ok, transform_func} ->
        S3.store_file(transform_func, email_address)

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
