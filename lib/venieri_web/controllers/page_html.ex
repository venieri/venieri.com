defmodule VenieriWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use VenieriWeb, :html

  import VenieriWeb.Components.Navbar

  embed_templates "page_html/*"
end
