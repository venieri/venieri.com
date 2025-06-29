# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :venieri, :scopes,
  user: [
    default: true,
    module: Venieri.Accounts.Scope,
    assign_key: :current_scope,
    access_path: [:user, :id],
    schema_key: :user_id,
    schema_type: :id,
    schema_table: :users,
    test_data_fixture: Venieri.AccountsFixtures,
    test_login_helper: :register_and_log_in_user
  ]

config :venieri,
  ecto_repos: [Venieri.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :venieri, VenieriWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: VenieriWeb.ErrorHTML, json: VenieriWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Venieri.PubSub,
  live_view: [signing_salt: "LiFybn0M"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :venieri, Venieri.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  venieri: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.0.9",
  venieri: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :backpex,
  pubsub_server: Venieri.PubSub,
  translator_function: {VenieriWeb.CoreComponents, :translate_backpex},
  error_translator_function: {VenieriWeb.CoreComponents, :translate_error}

config :venieri, Oban,
  engine: Oban.Engines.Basic,
  queues: [default: 5],
  repo: Venieri.Repo

config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")

config :snowflake,
  # values are 0 thru 1023 nodes
  machine_id: 23,
  epoch: 1_737_948_183_000

config :venieri, :uploads,
  upload_path: "uploads/media",
  media_path: "static/media",
  upload_bucket: "venieri.com"

config :flop, repo: Venieri.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
