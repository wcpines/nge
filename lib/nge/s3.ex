# lib/nge/s3.ex
defmodule Nge.S3 do
  @bucket Application.get_env(:nge, :s3_storage_bucket_name)

  # TODO test this
  def store_file(streamed_activity_data, username) do
    content = stream_to_string(streamed_activity_data)

    ExAws.S3.put_object(@bucket, filename(username), content)
    |> ExAws.request!()
  end

  defp stream_to_string(streamed_activity_data) do
    Enum.into(streamed_activity_data, "")
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
