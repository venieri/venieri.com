defmodule VenieriWeb.EventList do
  use VenieriWeb, :live_view
  require Logger
  alias Venieri.Archives.Events
  alias Venieri.Archives.Models.Event

  import VenieriWeb.Components.Navbar

  @impl true
  def render(assigns) do
    ~H"""
     <.navbar socket={@socket}/>

      <div id="event-list-container">
        <div >
          <ul id="event-list" id="infinite-scroll-body" phx-update="append">
            <%= for event <- @events  do %>
              <%= if event.show do %>
                <li id={"li-#{event.id}"} class="p-10">
                  <.event_card event={event} />
                </li>
              <% end %>
            <% end %>
          </ul>
        </div>
        <div id="infinite-scroll-marker" phx-hook="InfiniteScroll" data-page={@page}></div>
      </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # socket = assign(socket, page: 1)

    # # on initial load it'll return false,
    # # then true on the next.
    # if connected?(socket) do
    #   get_events(socket)
    # else
    #   socket
    # end

    {:ok,
     socket
     |> assign(page: 0), temporary_assigns: [events: []]}
  end

  @impl true
  def handle_event("load-more", _, %{assigns: assigns} = socket) do
    Logger.info("load-more #{assigns.page}")
    {:noreply, assign(socket, page: assigns.page + 1) |> get_events()}
  end

  defp get_events(%{assigns: %{page: page}} = socket) do
    {:ok, {events, _}} = Events.page(%{page: page})

    socket
    |> assign(page: page)
    |> assign(events: events)
  end

  def event_card(assigns) do
    ~H"""

    <%= if @event.orientation == "auto" and Events.is_media_poster_horizontal?(@event) do %>
      <div class="h-1/2 bg-white shadow-sm">
          <a href="#">
              <img class="object-cover w-full  md:h-auto"
                    src={"/media/" <> Venieri.Archives.Events.image_url(@event, 640)}
              alt="" />
          </a>
          <div class="p-5">
              <a href="#">
                  <h2 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"><%= @event.title %></h2>
              </a>
              <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">
                  <time id="date-{@event.id}"><%= date(@event.start_date) %></time>
                  <address id="date-{@event.id}" class="text-sm font-bold text-gray-900"><%= @event.venue %></address>

              </p>
              <p class="mb-3 font-normal text-gray-700 dark:text-gray-400 truncate text-ellipsis"><%= Phoenix.HTML.raw(@event.leader |> String.slice(0, 140)) %></p>
            </div>
        </div>
        <% end %>
    <%= if @event.orientation == "Horizontal" do %>
      <div class="h-1/2 bg-white shadow-sm">
          <a href="#">
              <img class="object-cover w-full  md:h-auto"
                    src={"/media/" <> Venieri.Archives.Events.image_url(@event, 640)}
              alt="" />
          </a>
          <div class="p-5">
              <a href="#">
                  <h2 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"><%= @event.title %></h2>
              </a>
              <p class="mb-3 font-normal text-gray-700 dark:text-gray-400">
                  <time id="date-{@event.id}"><%= date(@event.start_date) %></time>
                  <address id="date-{@event.id}" class="text-sm font-bold text-gray-900"><%= @event.venue %></address>

              </p>
              <p class="mb-3 font-normal text-gray-700 dark:text-gray-400 truncate text-ellipsis"><%= Phoenix.HTML.raw(@event.leader |> String.slice(0, 140)) %></p>
            </div>
        </div>
        <% end %>
        <%= if @event.orientation == "auto" and Events.is_media_poster_horizontal?(@event) == false do %>
          <div id={"card-#{@event.id}"} class="flex flex-col items-center bg-white shadow-sm md:flex-row">
              <img id={"img-#{@event.id}"} class="object-cover w-full"
              src={"/media/" <> Venieri.Archives.Events.image_url(@event, 640)}
              alt="">
              <div class="flex flex-col justify-between p-4 leading-normal">
                  <h2 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"><%= @event.title %></h2>
                  <time id="date-{@event.id}"><%= date(@event.start_date) %></time>
                  <address id="date-{@event.id}" class="text-sm font-bold text-gray-900"><%= @event.venue %></address>
                  <p class="mb-3 font-normal text-gray-700 dark:text-gray-400  max-h-20  text-ellipsis"><%= Phoenix.HTML.raw(@event.leader |> String.slice(0, 140)) %></p>
              </div>
          </div>
      <% end %>
 <%= if @event.orientation == "Left" do %>
          <div id={"card-#{@event.id}"} class="flex flex-col items-center bg-white shadow-sm md:flex-row">
              <img id={"img-#{@event.id}"} class="object-cover w-full"
              src={"/media/" <> Venieri.Archives.Events.image_url(@event, 640)}
              alt="">
              <div class="flex flex-col justify-between p-4 leading-normal">
                  <h2 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"><%= @event.title %></h2>
                  <time id="date-{@event.id}"><%= date(@event.start_date) %></time>
                  <address id="date-{@event.id}" class="text-sm font-bold text-gray-900"><%= @event.venue %></address>
                  <p class="mb-3 font-normal text-gray-700 dark:text-gray-400  max-h-20  text-ellipsis"><%= Phoenix.HTML.raw(@event.leader |> String.slice(0, 140)) %></p>
              </div>
          </div>
  <% end %>

   <%= if @event.orientation == "Right" do %>

          <div id={"card-#{@event.id}"} class="flex flex-col items-center bg-white shadow-sm md:flex-row">
          <div class="flex flex-col justify-between p-4 leading-normal">
                  <h2 class="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-white"><%= @event.title %></h2>
                  <time id="date-{@event.id}"><%= date(@event.start_date) %></time>
                  <address id="date-{@event.id}" class="text-sm font-bold text-gray-900"><%= @event.venue %></address>
                  <p class="mb-3 font-normal text-gray-700 dark:text-gray-400  max-h-20  text-ellipsis"><%= Phoenix.HTML.raw(@event.leader |> String.slice(0, 140)) %></p>
          </div>
          <img id={"img-#{@event.id}"} class="object-cover w-full"
          src={"/media/" <> Venieri.Archives.Events.image_url(@event, 640)}
          alt="">
      </div>
  <% end %>


      """
  end

  def date(date) do
    if Date.before?(date, Date.utc_today()) do
      Calendar.strftime(date, "%B %Y")
    else
      Calendar.strftime(date, "%d %B %Y")
    end
  end

  def date_tag(assigns) do
    ~H"""
      <%= if Date.before?(@date, Date.utc_today()) do %>
        <%= Calendar.strftime(assigns.date, "%B %Y") %>
      <% else %>
        <time datetime={@date}><%= Calendar.strftime(assigns.date, "%d %B %Y") %></time>
      <% end %>
    """
  end

  def event_card_old(assigns) do
        ~H"""
          <div id={"card-#{@event.id}"} class="divide-y divide-gray-200 overflow-hidden rounded-lg bg-white shadow">
          <div id={"cardhd-#{@event.id}"} class="px-4 py-5 sm:px-6">
              <h2 id={"title-#{@event.id}"} class="text-2xl font-extrabold dark:text-white"><%= @event.title %></h2>
            <span id="date-{@event.id}"><%= @event.start_date %></span>
          </div>
          <div id={"cardimg-#{@event.id}"} class="px-4 py-5 sm:p-6">
              <img  id={"img-#{@event.id}"} class="object-cover w-full  md:h-auto"
              src={"/media/" <> Venieri.Archives.Events.image_url(@event, 640)} alt="" />
          </div>
          <div id={"carddesc-#{@event.id}"} class="px-4 py-4 sm:px-6">
              <%= Phoenix.HTML.raw(@event.leader) %>
          </div>
        </div>
        """
  end
end
