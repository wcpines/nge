# lib/nge/s3.ex
defmodule Nge.S3 do
  @bucket Application.get_env(:nge, :s3_storage_bucket_name)
  def store_file(streamed_activity_data, username) do
    streamed_activity_data
    |> ExAws.S3.upload(@bucket, filename(username))
    |> ExAws.request!()
  end

  defp filename(username) do
    "#{username}/activity_logs_#{timestamp()}.csv"
  end

  defp timestamp do
    DateTime.utc_now()
    |> DateTime.to_unix()
    |> to_string
  end
end
