# config/test.exs
import Config

config :nge,
  strava_api_adapter: Nge.MockStravaApiAdapter,
  csv_parser: Nge.MockCSVParser
