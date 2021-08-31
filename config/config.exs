# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :virgo,
  namespace: AstraeaVirgo,
  base_url: System.get_env("BASE_URL") || "http://example.com"

# Configures the endpoint
config :virgo, AstraeaVirgoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OqhtMHS1YwWJBT+NuFaod2FeUbj8KRCdjnz8SPOEUlPsnxoIDdhKXVVhcjtAfqqW",
  render_errors: [view: AstraeaVirgoWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: AstraeaVirgo.PubSub,
  live_view: [signing_salt: "mzAaAQ4+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Snowflake
config :snowflake,
  nodes: ["localhost"],
  epoch: System.get_env("SNOWFLAKE_EPOCH", "1620748800000") |> String.to_integer()

# Configures Redis
config :virgo, :cache,
  host: System.get_env("REDIS_HOST") || "localhost",
  port: (System.get_env("REDIS_PORT") || "6379") |> String.to_integer(),
  password: System.get_env("REDIS_PASSWORD") || nil

# Configures RabbitMQ
config :virgo, :amqp,
  username: System.get_env("AMQP_USERNAME") || "guest",
  password: System.get_env("AMQP_PASSWORD") || "guest",
  host: System.get_env("AMQP_HOST") || "localhost",
  port: (System.get_env("AMQP_PORT") || "5672") |> String.to_integer()

# Configures Thrift
config :virgo, :rpc,
  host: System.get_env("RPC_HOST") || "localhost",
  port: (System.get_env("RPC_PORT") || "5450") |> String.to_integer()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
