use Mix.Config

config :nge,
  activity_log: System.get_env("RUNNING_LOGS"),
  strava_data_path: System.get_env("ACTIVITY_LOGS_PATH"),
  http: [protocol_options: [idle_timeout: 10_000_000]],
  s3_storage_bucket_name: System.get_env("AWS_S3_STORAGE_BUCKET_NAME"),
  s3: Nge.S3

config :strava,
  client_id: System.get_env("STRAVA_CLIENT_ID"),
  client_secret: System.get_env("STRAVA_CLIENT_SECRET"),
  access_token: System.get_env("STRAVA_ACCESS_TOKEN"),
  refresh_token: System.get_env("STRAVA_REFRESH_TOKEN"),
  redirect_uri: "http://localhost:4000/import"

config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("AWS_S3_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_S3_SECRET_ACCESS_KEY"),
  s3: [region: "us-west-1", scheme: "https://"]

config :ex_aws, :hackney_opts,
  follow_redirect: true,
  recv_timeout: 30_000
