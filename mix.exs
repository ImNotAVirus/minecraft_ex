defmodule MinecraftEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :minecraft_ex,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ssh, :inets],
      mod: {MinecraftEx.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elvengard_network, github: "imnotavirus/elvengard_network"},
      {:poison, "~> 5.0"}
    ]
  end
end
