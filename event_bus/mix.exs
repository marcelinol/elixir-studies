defmodule EventBus.Mixfile do
  use Mix.Project

  def project do
    [
      app: :event_bus,
      version: "0.1.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EventBus, []} # This tells OTP which module contains our main application, and any arguments we want to pass to it
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:plug, "~> 1.3"},
      {:poison, "~> 3.0"}, # NOTE: Poison is necessary only if you care about parsing/generating JSON
    ]
  end
end
