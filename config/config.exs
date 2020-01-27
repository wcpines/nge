# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :nge,
  activity_log: System.get_env("RUNNING_LOGS"),
  strava_data_path: System.get_env("ACTIVITY_LOGS_PATH")

config :strava,
  client_id: System.get_env("STRAVA_CLIENT_ID"),
  client_secret: System.get_env("STRAVA_CLIENT_SECRET"),
  access_token: System.get_env("STRAVA_ACCESS_TOKEN"),
  refresh_token: System.get_env("STRAVA_REFRESH_TOKEN"),
  redirect_uri: "https://1b5e0ad0.ngrok.io"
