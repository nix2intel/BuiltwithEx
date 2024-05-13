defmodule Builtwith.MixProject do
  use Mix.Project

  def project do
    [
      app: :builtwith,
      version: "0.1.0",
      elixir: ">= 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()

      # Docs
      name: "Builtwith Elixir",
      source_url: "https://github.com/nix2intel/builtwith",
      docs: [
        main: "Builtwith", # The main page in the docs
        logo: "bwelixir.png",
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:jason, "~> 1.2"}
    ]
  end
end
