defmodule VenieriWeb.VirtualWorld do
  alias VenieriWeb.VirtualWorld
  use VenieriWeb, :live_view
  require Logger

  import VenieriWeb.Components.Navbar

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:bg_color, "bg-black")}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto p-3 px-20">

      <div class="flex items-center justify-center max-h-screen p-4">
        <%!-- <div class="flex bg-gray-200 p-4 max-w-full max-h-full overflow-auto"> --%>
        <div class="grid grid-flow-row-dense content-center grid-cols-3 grid-rows-3 gap-4 p-20 max-w-screen max-h-screen">
          <div class="justify-self-end">
            <a href="/virtual-world/apology/index.html">
              <img
                class="h-32"
                src="https://venieri.com/virtual-world/apology/apicon.gif"
                alt=" apology"
              />
            </a>
          </div>
          <div class="justify-self-start">
            <a href="/virtual-world/HerStory/hers001.html">
              <img
                class="h-32"
                src="https://venieri.com/virtual-world/images/herstory.gif"
                alt=" apology"
              />
            </a>
          </div>
          <div class="justify-self-start">
            <a href="/virtual-world/apology/index.html">
              <img
                class="h-32"
                src="https://www.venieri.com/virtual-world/modelc/images/iimodel.gif"
                alt=" apology"
              />
            </a>
          </div>
          <div class="justify-self-end">
            <a href="/virtual-world/apology/index.html">
              <img
                class="h-32"
                src="https://venieri.com/virtual-world/images/ifin.gif"
                alt=" apology"
              />
            </a>
          </div>
          <div class="roh-span-2 -span-2">
            <a href="/">
              <img class="w-96" src="https://venieri.com/virtual-world/images/ilydia.gif" alt="" />
            </a>
          </div>
          <div class="justify-self-end">
            <a href="/virtual-world/apology/index.html">
              <img
                class="h-32"
                src="https://venieri.com/virtual-world/images/isis.gif"
                alt=" apology"
              />
            </a>
          </div>
          <div class="justify-self-start">
            <a href="/virtual-world/apology/index.html">
              <img
                class="h-32"
                src="https://venieri.com/virtual-world/images/imartha.gif"
                alt=" apology"
              />
            </a>
          </div>
          <div class="justify-self-start">
            <a href="/virtual-world/apology/index.html">
              <img
                class="h-32"
                src="https://venieri.com/virtual-world/images/iegg.gif"
                alt=" apology"
              />
            </a>
          </div>
          <div class="justify-self-end">
            <a href="/virtual-world/apology/index.html">
              <img
                class="h-32"
                src="https://venieri.com/virtual-world/images/tarota.gif"
                alt=" apology"
              />
            </a>
          </div>
          <div class="justify-self-end">
            <a href="/virtual-world/apology/index.html">
              <img
                class="h-32"
                src="https://venieri.com/virtual-world/images/mail.gif"
                alt=" apology"
              />
            </a>
          </div>
          <div class="justify-self-stretch">
            <a href="/virtual-world/apology/index.html">
              <img
                class="h-32"
                src="https://venieri.com/virtual-world/images/alicon.gif"
                alt=" apology"
              />
            </a>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
