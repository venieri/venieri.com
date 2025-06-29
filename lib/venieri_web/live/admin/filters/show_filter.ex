defmodule VenieriWeb.Admin.Filters.ShowFilter do
  @moduledoc """
  Implementation of the `Backpex.Filters.Boolean` behaviour.
  """

  use Backpex.Filters.Boolean

  @impl Backpex.Filter
  def label, do: "Show?"

  @impl Backpex.Filters.Boolean
  def options do
    [
      %{
        label: "Showing",
        key: "showing",
        predicate: dynamic([x], x.show)
      },
      %{
        label: "Not showing",
        key: "not_showing",
        predicate: dynamic([x], not x.show)
      }
    ]
  end
end
