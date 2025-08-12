defmodule VenieriWeb.MediaController do
  use VenieriWeb, :controller

  def export(conn, %{"slug" => slug}) do
    media = Venieri.Archives.Media.get_by(slug: slug)
    url = Venieri.Archives.Media.url(media)

    path =
      Application.app_dir(:venieri, "priv/static/media2/#{media.slug}/#{media.slug}-A4.webp")
    conn
    |> send_download(
      {:file, path},
      content_type: "image/webp",
      filename: "lydia-venieri-#{media.slug}-A4.webp",
      disposition: :inline
    )
  end
end
