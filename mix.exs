defmodule Venieri.MixProject do
  use Mix.Project

  def project do
    [
      app: :venieri,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
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
      {:argon2_elixir, "~> 4.1"},
      {:bcrypt_elixir, "~> 3.0"},
      {:phoenix, "~> 1.7.18"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "~> 1.5"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"}
    ] ++ [
      {:ex_aws, "~> 2.1.2"},
      {:ex_aws_s3, "~> 2.0"},
      {:backpex,  git: "https://github.com/naymspace/backpex.git"},
      # {:backpex, path: "/Users/thanos/work/backpex"},
      {:ecto_autoslug_field, "~> 3.1"},
      {:exiftool, "~> 0.2.0"},
      {:flop_phoenix, "~> 0.23.0"},
      {:image, "~> 0.55.2"},
      {:json_ld, "~> 0.3.9"},
      {:live_monaco_editor, "~> 0.1"},
      {:mogrify, "~> 0.9.3"},
      {:oban, "~> 2.19"},
      {:oban_web, "~> 2.11"},
      {:phoenix_seo, "~> 0.1.11"},
      {:snowflake, "~> 1.0.0"},
      {:temp, "~> 0.4.9"},
      {:ueberauth, "~> 0.10.8"},
      {:ueberauth_microsoft, "~> 0.23.0"},
      {:ueberauth_google, "~> 0.12.1"},
      {:ueberauth_facebook, "~> 0.10.0"},
      {:ueberauth_twitter, "~> 0.4.1"},
      {:ueberauth_apple, "~> 0.6.1"},
      {:ueberauth_linkedin, "~> 0.10.8", hex: :ueberauth_linkedin_modern},
      {:ueberauth_github, "~> 0.8.3"},
      {:ueberauth_identity, "~> 0.4.2"},
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
