defmodule AstraeaVirgo.MixProject do
  use Mix.Project

  def project do
    [
      app: :virgo,
      version: "0.1.0",
      elixir: "~> 1.7",
      erlc_paths: ["src"],
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AstraeaVirgo.Application, []},
      extra_applications: [:logger, :runtime_tools, :snowflake]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.7"},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:distillery, "~> 2.0"},
      {:exop, "~> 1.0"},
      {:timex, "~> 3.0"},
      {:redix, "~> 1.0"},
      {:amqp, "~> 2.0"},
      {:thrift, git: "https://github.com/apache/thrift", sparse: "lib/erl", tag: "v0.14.1"},
      {:snowflake, "~> 1.0"},
      {:guardian, "~> 2.0"},
      {:elixir_uuid, "~> 1.0"},
      # {:mongo, "~> 0.5.1"},
      {:csv, "~> 2.0"},
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.0", only: :dev},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end
end
