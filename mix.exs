defmodule Builtwith.MixProject do
  use Mix.Project

  def project do
    [
      app: :builtwith,
      version: "0.1.1",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "An unofficial module for interacting with the Builtwith API.",

      # Docs

      docs: [
        main: "builtwith", # The main page in the docs
        logo: "bwelixir.png",
        extras: ["builtwith.livemd"]
      ]
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "builtwith",
      # These are the default files included in the package
      files: ~w(lib priv .formatter.exs mix.exs LICENSE*),
      licenses: ["BSD 3-Clause"],
      links: %{"GitHub" => "https://github.com/nix2intel/builtwith"}
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
      {:httpoison, "~> 2.2.1"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:jason, "~> 1.4.1"}
    ]
  end
end
