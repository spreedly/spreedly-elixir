defmodule Spreedly.Mixfile do
  use Mix.Project

  def project do
    [app: :spreedly,
     version: "2.0.2",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     description: description(),
     package: package(),
     deps: deps(),
     dialyzer: [ignore_warnings: "dialyzer.ignore-warnings"]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:hackney, "~> 1.7 or ~> 1.8"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:poison, "~> 2.0 or ~> 3.0"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp description do
    """
    A wrapper for the Spreedly API.
    """
  end

  defp package do
    [
      maintainers: ["Duff O'Melia <duff@omelia.org>","Jared Knipp <jared@spreedly.com>"],
      licenses:    ["MIT"],
      links:       %{"GitHub" => "https://github.com/spreedly/spreedly-elixir"}
    ]
  end

end
