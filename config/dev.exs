# config/dev.exs
import Config

config :nge,
  activity_log: System.get_env("RUNNING_LOGS"),
  strava_api_adapter: Nge.StubStravaApiAdapter
