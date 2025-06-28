defmodule Venieri.MixProject do
  use Mix.Project

  def project do
    [
      app: :venieri,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      listeners: [Phoenix.CodeReloader]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Venieri.Application, []},
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
      {:bcrypt_elixir, "~> 3.0"},
      {:phoenix, "~> 1.8.0-rc.0", override: true},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.9", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.3", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.16"},
      {:req, "~> 0.5"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"}
    ] ++
      [
        # {:backpex, git: "https://github.com/naymspace/backpex.git"}
        {:backpex, "~> 0.13.0"},
        {:ecto_autoslug_field, "~> 3.1"},
        {:ecto_hooks, "~> 1.2"},
        {:ex_aws_s3, "~> 2.5"},
        {:ex_aws, "~> 2.5"},
        {:exiftool, "~> 0.2.0"},
        {:ffmpex, "~> 0.11.0"},
        {:flop_phoenix, "~> 0.25.1"},
        {:hackney, "~> 1.9"},
        {:igniter, "~> 0.6", only: [:dev, :test]},
        {:image, "~> 0.59.0"},
        {:mogrify, "~> 0.9.3"},
        {:oban_web, "~> 2.11"},
        {:oban, "~> 2.19"},
        {:phoenix_seo, "~> 0.1.11"},
        # {:romanex, "~> 0.1.0"}
        {:snowflake, "~> 1.0"},
        {:timex, "~> 3.7"},
        {:live_debugger, "~> 0.2.0", only: :dev}
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
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind venieri", "esbuild venieri"],
      "assets.deploy": [
        "tailwind venieri --minify",
        "esbuild venieri --minify",
        "phx.digest"
      ]
    ]
  end
end
