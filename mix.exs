defmodule Nge.MixProject do
  use Mix.Project

  def project do
    [
      app: :nge,
      version: "0.1.0",
      elixir: "~> 1.8",
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
      {:csv, "~> 2.3"},
      {:plug, "~> 1.9"},
      {:plug_cowboy, "~> 2.0"},
      {:strava, "~> 1.0"}
    ]
  end
end
