defmodule Venieri.Archives.ImageProcessor do
  @moduledoc """
  A module to handle image processing tasks like removing EXIF data.
  """
  use Oban.Worker
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"action" => "upload_s3"} = args}) do
    %{"media_id" => media_id} = args
    media = Venieri.Archives.Media.get!(media_id)
    src = Venieri.Archives.Media.get_upload_file(media)
    bucket = Application.fetch_env!(:venieri, :uploads)[:upload_bucket]

    key =
      Path.join([Application.fetch_env!(:venieri, :uploads)[:upload_path], media.uploaded_file])

    src
    |> ExAws.S3.Upload.stream_file()
    |> ExAws.S3.upload(bucket, key)
    |> ExAws.request()
    |> case do
      {:ok, %{status_code: 200}} ->
        :ok

      {:error, error} ->
        Logger.error("Error uploading to S3: #{inspect(error)}")
        :error
    end
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"action" => "gen_press_quality"} = args}) do
    %{"media_id" => media_id} = args
    media = Venieri.Archives.Media.get!(media_id)
    Venieri.Archives.Media.gen_press_quality(media)
    :ok
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"action" => "gen_web_images"} = args}) do
    %{"media_id" => media_id} = args

    [480, 640, 768, 1024, 1280, 1536, 1920, 2560, 3840, 4096, 5120, 7680]
    |> Enum.each(fn width ->
      __MODULE__.new(%{
        "action" => "resize_for_web",
        "media_id" => media_id,
        "width" => width
      })
      |> Oban.insert()
    end)

    :ok
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"action" => "resize_for_web"} = args}) do
    %{"media_id" => media_id, "width" => width} = args
    media = Venieri.Archives.Media.get!(media_id)
    Venieri.Archives.Media.gen_thumbnail(media, width)
    :ok
  end
end
