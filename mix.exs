defmodule Dropper.MixProject do
  use Mix.Project

  def project do
    [
      app: :dropper,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Dropper.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:distillery, "~> 1.5", runtime: false},
      {:grpc, github: "tony612/grpc-elixir"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"}
    ]
  end
end
