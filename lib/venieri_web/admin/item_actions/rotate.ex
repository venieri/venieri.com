defmodule VenieriWeb.Admin.ItemActions.Rotate do
  use BackpexWeb, :item_action

  @impl Backpex.ItemAction


  def icon(assigns, _item) do
    ~H"""
    <Backpex.HTML.CoreComponents.icon
      name="hero-arrow-path"
      class="h-5 w-5 cursor-pointer transition duration-75 hover:scale-110 hover:text-green-600"
    />
    """
  end

  @impl Backpex.ItemAction
  def label(_assigns, nil), do: "Rotate"
  def label(_assigns, item), do: "Rotate #{item.caption}"



  @impl Backpex.ItemAction
  def handle(socket, [item | _items], _data) do
    path = Router.get_path(socket, socket.assigns.live_resource, socket.assigns.params, :show, item)
    {:noreply, Phoenix.LiveView.push_patch(socket, to: path)}
  end
end
