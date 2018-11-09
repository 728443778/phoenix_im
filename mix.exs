defmodule PhoenixIm.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_im,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PhoenixIm, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_html, "~> 2.11"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:jason, "~> 1.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:gettext, "~> 0.11"},
      {:distillery, "~> 2.0"}
    ]
  end
end
