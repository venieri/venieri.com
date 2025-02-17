defmodule VenieriWeb.Admin.ItemActions.Process do
  use BackpexWeb, :item_action

  @impl Backpex.ItemAction

  alias Venieri.Archives.Media

  def icon(assigns, _item) do
    ~H"""
    <Backpex.HTML.CoreComponents.icon
      name="hero-arrow-path"
      class="h-5 w-5 cursor-pointer transition duration-75 hover:scale-110 hover:text-green-600"
    />
    """
  end

  @impl Backpex.ItemAction
  def label(_assigns, nil), do: "Process"
  def label(_assigns, item), do: "Process #{item.caption}"



  @impl Backpex.ItemAction
  def handle(socket, items, _data) do
    items
    |> Enum.each(fn item ->
      Media.process(item)
    end)
    socket =
      socket
      |> clear_flash()
      |> put_flash(:info, success_message(socket.assigns, items))
    {:ok, socket}
  end

  defp success_message(assigns, [_item]) do
    Backpex.translate({"%{resource} has been added to the process queue successfully.", %{resource: assigns.singular_name}})
  end

  defp success_message(assigns, items) do
    Backpex.translate(
      {"%{count} %{resources} have added to the process queue successfully.",
       %{resources: assigns.plural_name, count: Enum.count(items)}}
    )
  end

end
