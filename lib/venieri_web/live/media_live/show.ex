defmodule VenieriWeb.MediaLive.Show do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Media
  alias Venieri.Archives.Models.Media


  import VenieriWeb.Components.Navbar

  @impl true
  def render(assigns) do
    ~H"""

<.navbar socket={@socket} />

    <figure class="flex flex-col items-center justify-center pt-4 pb-8">




   <img src={"#{Venieri.Archives.Media.url(@media)}"} alt={@media.caption} />

   <figcaption>{@media.caption}</figcaption>
   <p class="flex-1">
<button class="flex-btn btn-ghost text-xs">
  press quality
  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
  <path stroke-linecap="round" stroke-linejoin="round" d="M9 8.25H7.5a2.25 2.25 0 0 0-2.25 2.25v9a2.25 2.25 0 0 0 2.25 2.25h9a2.25 2.25 0 0 0 2.25-2.25v-9a2.25 2.25 0 0 0-2.25-2.25H15M9 12l3 3m0 0 3-3m-3 3V2.25" />
</svg>

</button>
</p>
   </figure>
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    media = Venieri.Archives.Media.get_by(slug: slug)
    {:ok,
     socket
     |> assign(:page_title, media.caption)
     |> assign(:media,  media)}
  end






end
