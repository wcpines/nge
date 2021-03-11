defmodule Nge.MixProject do
  use Mix.Project

  def project do
    [
      app: :nge,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Nge, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:csv, "~> 2.4"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.1"},
      {:jason, "~> 1.2"},
      {:plug, "~> 1.11"},
      {:plug_cowboy, "~> 2.4"},
      {:strava, "~> 1.0"},
      {:sweet_xml, "~> 0.6"}
    ]
  end
end
