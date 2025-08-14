defmodule VenieriWeb.Components.Navbar do
  @moduledoc """
  Provides core UI components.


  """
  use Phoenix.Component
  use Gettext, backend: VenieriWeb.Gettext


  def navbar_center(assigns) do
    ~H"""
  <div class="navbar">
  <div class="navbar-start">
    <div class="dropdown">
      <div tabindex="0" role="button" class="btn btn-ghost lg:hidden">
      <img class="block h-5 w-auto lg:hidden" src="/images/hers016.webp" alt="Lydia Venieri" />
      <img class="hidden h-16 w-auto lg:block" src="/images/hers016.webp" alt="Lydia Venieri" />
        </div>
      <ul
        tabindex="0"
        class="menu menu-sm dropdown-content bg-base-100 rounded-box z-1 mt-3 w-52 p-2 shadow">
        <li><a href="/" page={VenieriWeb.EventList}>LYDIA VENIERI</a></li>
        <li><a href="/bio" page={VenieriWeb.BioLive}>BIO</a></li>
        <li>
          <a href="/projects" page={VenieriWeb.ProjectsLive}>PROJECTS</a>
        </li>
        <li><a href="/virtual-world" page={VenieriWeb.VirtualWorldLive}>VIRTUAL WORLD</a></li>
      </ul>
    </div>
    <img class="hidden h-16 w-auto lg:block" src="/images/hers016.webp" alt="Lydia Venieri" />
  </div>
  <div class="navbar hidden lg:flex">
    <ul class="menu menu-horizontal px-1">
      <li><a href="/" page={VenieriWeb.EventList}>LYDIA VENIERI</a></li>
      <li><a href="/bio" page={VenieriWeb.BioLive}>BIO</a></li>
      <li><a href="/projects" page={VenieriWeb.ProjectsLive}>PROJECTS</a></li>
      <li><a href="/virtual-world" page={VenieriWeb.VirtualWorldLive}>VIRTUAL WORLD</a></li>
    </ul>
  </div>
</div>
"""
  end

  def navbar(assigns) do
    ~H"""
  <div class="navbar">
    <div class="dropdown">
      <div tabindex="0" role="button" class="btn btn-ghost lg:hidden">
      <img class="block h-5 w-auto lg:hidden" src="/images/hers016.webp" alt="Lydia Venieri" />
      <img class="hidden h-16 w-auto lg:block" src="/images/hers016.webp" alt="Lydia Venieri" />
        </div>
      <ul
        tabindex="0"
        class="menu menu-sm dropdown-content bg-base-100 rounded-box z-1 mt-3 w-52 p-2 shadow">
        <li><a href="/" page={VenieriWeb.EventList}>LYDIA VENIERI</a></li>
        <li><a href="/bio" page={VenieriWeb.BioLive}>BIO</a></li>
        <li>
          <a href="/projects" page={VenieriWeb.ProjectsLive}>PROJECTS</a>
        </li>
        <li><a href="/virtual-world" page={VenieriWeb.VirtualWorldLive}>VIRTUAL WORLD</a></li>
      </ul>
    </div>
    <img class="hidden h-16 w-auto lg:block" src="/images/hers016.webp" alt="Lydia Venieri" />

  <div class="navbar hidden lg:flex">
    <ul class="menu menu-horizontal px-1">
      <li><a href="/" page={VenieriWeb.EventList}>LYDIA VENIERI</a></li>
      <li><a href="/bio" page={VenieriWeb.BioLive}>BIO</a></li>
      <li><a href="/projects" page={VenieriWeb.ProjectsLive}>PROJECTS</a></li>
      <li><a href="/virtual-world" page={VenieriWeb.VirtualWorldLive}>VIRTUAL WORLD</a></li>
    </ul>
  </div>
</div>
"""
  end

  def nav_bar(assigns) do
    ~H"""
    <nav>
      <div class="mx-auto">
        <div class="flex justify-center">
          <div class="flex">
            <div class="flex shrink-0 items-center">
              <img class="block h-5 w-auto lg:hidden" src="/images/hers016.webp" alt="Lydia Venieri" />
              <img class="hidden h-16 w-auto lg:block" src="/images/hers016.webp" alt="Lydia Venieri" />
            </div>
            <div class="hidden sm:-my-px sm:ml-6 sm:flex sm:space-x-8">

    <!-- Current: "border-indigo-500 text-gray-900", Default: "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700" -->
              <.nav_item socket={@socket} link="/" page={VenieriWeb.EventList} tab="LYDIA VENIERI" />

              <.nav_item socket={@socket} link="/bio" page={VenieriWeb.BioLive} tab="BIO" />
              <.nav_item
                socket={@socket}
                link="/projects"
                page={VenieriWeb.ProjectsLive}
                tab="PROJECTS"
              />
              <.nav_item
                socket={@socket}
                link="/virtual-world"
                page={VenieriWeb.VirtualWorldLive}
                tab="VIRTUAL WORLD"
              />
              <%!-- <div class="inline-flex items-center">
      <input type="text" placeholder="Search" class="input input-bordered h-1/2 md:w-auto" />
    </div> --%>
            </div>
            <div class="sm:hidden sm:-my-px sm:ml-6 sm:flex sm:space-x-8">
              <!-- Current: "border-indigo-500 text-gray-900", Default: "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700" -->
              <%= if @socket.view == VenieriWeb.EventList do %>
                <a
                  href=""
                  class="inline-flex items-center border-b-2 border-indigo-500 px-1 pt-1 text-xs font-medium text-gray-900"
                  aria-current="page"
                  style="font-size: 8px;"
                >
                  XLYDIA VENIERI
                </a>
              <% else %>
                <a
                  href="/"
                  class="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-xs font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                  style="font-size: 6px;"
                >
                  LYDIA VENIERI
                </a>
              <% end %>
              <a
                href="/bio"
                class="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-xs font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                style="font-size: 6px;"
              >
                BIO
              </a>
              <a
                href="/projects"
                class="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-xs font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                style="font-size: 6px;"
              >
                PROJECTS
              </a>
              <a
                href="/virtual-world"
                class="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-xs font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                style="font-size: 6px;"
              >
                VIRTUAL WORLD
              </a>
            </div>
          </div>
        </div>
      </div>
    </nav>
    """
  end

  def nav_item(assigns) do
    ~H"""
    <%= if @socket.view == @page do %>
      <a
        href={@link}
        class="inline-flex items-center border-b-2 border-indigo-500 px-1 pt-1 text-sm font-medium text-gray-900"
        aria-current="page"
      >
        {@tab}
      </a>
    <% else %>
      <a
        href={@link}
        class="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
      >
        {@tab}
      </a>
    <% end %>
    """
  end
end
