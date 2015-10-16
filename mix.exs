defmodule Spreedly.Mixfile do
  use Mix.Project

  def project do
    [app: :spreedly,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     description: description,
     package: package,
     deps: deps]
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
      {:httpoison, "~> 0.7.4"},
      {:xml_builder, "~> 0.0.6"}
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
      maintainers: ["Duff OMelia <duff@omelia.org>"],
      licenses:    ["MIT"],
      links:       %{"GitHub" => "https://github.com/duff/spreedly-elixir"}
    ]
  end

end
