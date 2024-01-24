# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :wtrmln,
  ecto_repos: [Wtrmln.Repo],
  generators: [timestamp_type: :utc_datetime]

# FunWithFlags Config
config :fun_with_flags, :persistence,
  adapter: FunWithFlags.Store.Persistent.Ecto,
  repo: Wtrmln.Repo,
  ecto_table_name: "flag_toggles",
  ecto_primary_key_type: :id
config :fun_with_flags, :cache, enabled: false
config :fun_with_flags, :cache_bust_notifications, enabled: false

# Configures the endpoint
config :wtrmln, WtrmlnWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: WtrmlnWeb.ErrorHTML, json: WtrmlnWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Wtrmln.PubSub,
  live_view: [signing_salt: "ZuocjYA9"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
