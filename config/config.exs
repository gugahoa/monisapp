# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :monis_app,
  ecto_repos: [MonisApp.Repo]

# Configures the endpoint
config :monis_app, MonisAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "j3r0G53BqfKtXTgyWnvLHzpGc5U8ErUkJnGd1i7ookCf/NuzkYAtoyZYwbuUHgoZ",
  render_errors: [view: MonisAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MonisApp.PubSub,
  live_view: [signing_salt: "mFLcAUaV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
