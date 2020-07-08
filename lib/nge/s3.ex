# lib/nge/s3.ex
defmodule Nge.S3 do
  @bucket Application.get_env(:nge, :s3_storage_bucket_name)

  # TODO test this
  def store_file(streamed_activity_data, email_address) do
    content = stream_to_string(streamed_activity_data)

    filename = gen_filename(email_address)

    response =
      ExAws.S3.put_object(@bucket, filename, content)
      |> ExAws.request!()
      |> handle_response
  end

  def handle_response(%{status: 200} = response) do
    require IEx
    IEx.pry()
  end

  def handle_response(_) do
  end

  defp stream_to_string(streamed_activity_data) do
    Enum.into(streamed_activity_data, "")
  end

  defp gen_filename(email_address) do
    username(email_address) <>
      "/activity_logs_" <>
      timestamp() <>
      ".csv"
  end

  defp username(email_address) do
    email_address
    |> String.split("@")
    |> List.first()
  end

  defp timestamp do
    DateTime.utc_now()
    |> DateTime.to_unix()
    |> to_string
  end
end
