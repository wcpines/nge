defmodule Nge.MixProject do
  use Mix.Project

  def project do
    [
      app: :nge,
      deps: deps(),
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      version: "0.1.0",
      xref: [exclude: [IEx, IEx.Pry]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Nge, []}
    ]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:csv, "~> 2.4"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.1"},
      {:jason, "~> 1.2"},
      {:mox, "~> 1.0", only: :test},
      {:plug, "~> 1.11"},
      {:plug_cowboy, "~> 2.4"},
      {:strava, "~> 1.0"},
      {:sweet_xml, "~> 0.6"}
    ]
  end
end
