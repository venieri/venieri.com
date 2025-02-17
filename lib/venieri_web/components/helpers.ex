defmodule VenieriWeb.Components.Helpers do


  def fmt_date(date) do
    Calendar.strftime(date, "%B %Y")
  end

  def fmt_year(date) do
    Calendar.strftime(date, "%Y")
  end

  # def pagination_top(assigns) do
  #   ~H"""
  #   <% {what, lhs, rhs} = get_ranges(@meta) %>
  #   <nav class="flex items-center justify-between border-t border-gray-200 px-4 sm:px-0">
  #     <div class="-mt-px flex w-0 flex-1">
  #       <a
  #         href={"?page=#{@meta.previous_page}"}
  #         class="inline-flex items-center border-t-2 border-transparent pr-1 pt-4 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
  #       >
  #         <svg
  #           class="mr-3 h-5 w-5 text-gray-400"
  #           viewBox="0 0 20 20"
  #           fill="currentColor"
  #           aria-hidden="true"
  #           data-slot="icon"
  #         >
  #           <path
  #             fill-rule="evenodd"
  #             d="M18 10a.75.75 0 0 1-.75.75H4.66l2.1 1.95a.75.75 0 1 1-1.02 1.1l-3.5-3.25a.75.75 0 0 1 0-1.1l3.5-3.25a.75.75 0 1 1 1.02 1.1l-2.1 1.95h12.59A.75.75 0 0 1 18 10Z"
  #             clip-rule="evenodd"
  #           />
  #         </svg>
  #         Previous
  #       </a>
  #     </div>

  #     <div class="-mt-px flex w-0 flex-1 justify-end">
  #       <a
  #         href={"?page=#{@meta.next_page}"}
  #         class="inline-flex items-center border-t-2 border-transparent pl-1 pt-4 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
  #       >
  #         Next
  #         <svg
  #           class="ml-3 h-5 w-5 text-gray-400"
  #           viewBox="0 0 20 20"
  #           fill="currentColor"
  #           aria-hidden="true"
  #           data-slot="icon"
  #         >
  #           <path
  #             fill-rule="evenodd"
  #             d="M2 10a.75.75 0 0 1 .75-.75h12.59l-2.1-1.95a.75.75 0 1 1 1.02-1.1l3.5 3.25a.75.75 0 0 1 0 1.1l-3.5 3.25a.75.75 0 1 1-1.02-1.1l2.1-1.95H2.75A.75.75 0 0 1 2 10Z"
  #             clip-rule="evenodd"
  #           />
  #         </svg>
  #       </a>
  #     </div>
  #   </nav>
  #   """
  # end

  # def pagination_bottom(assigns) do
  #   ~H"""
  #   <% {what, lhs, rhs} = get_ranges(@meta) %>
  #   <nav class="flex items-center justify-between border-t border-gray-200 px-4 sm:px-0">
  #     <div class="-mt-px flex w-0 flex-1">
  #       <a
  #         href={"?page=#{@meta.previous_page}"}
  #         class="inline-flex items-center border-t-2 border-transparent pr-1 pt-4 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
  #       >
  #         <svg
  #           class="mr-3 h-5 w-5 text-gray-400"
  #           viewBox="0 0 20 20"
  #           fill="currentColor"
  #           aria-hidden="true"
  #           data-slot="icon"
  #         >
  #           <path
  #             fill-rule="evenodd"
  #             d="M18 10a.75.75 0 0 1-.75.75H4.66l2.1 1.95a.75.75 0 1 1-1.02 1.1l-3.5-3.25a.75.75 0 0 1 0-1.1l3.5-3.25a.75.75 0 1 1 1.02 1.1l-2.1 1.95h12.59A.75.75 0 0 1 18 10Z"
  #             clip-rule="evenodd"
  #           />
  #         </svg>
  #         Previous
  #       </a>
  #     </div>
  #     <div class="hidden md:-mt-px md:flex">
  #       <%= for page <- lhs do %>
  #         <a
  #           href={"?page=#{page}"}
  #           class="inline-flex items-center border-t-2 border-transparent px-4 pt-4 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
  #         >
  #           <%= page %>
  #         </a>
  #       <% end %>
  #       <!-- Current: "border-indigo-500 text-indigo-600", Default: "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300" -->
  #       <%= if what == :elipses do %>
  #         <span class="inline-flex items-center border-t-2 border-transparent px-4 pt-4 text-sm font-medium text-gray-500">
  #           ...
  #         </span>
  #         <%= for page <- rhs do %>
  #           <a
  #             href={"?page=#{page}"}
  #             class="inline-flex items-center border-t-2 border-transparent px-4 pt-4 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
  #           >
  #             <%= page %>
  #           </a>
  #         <% end %>
  #       <% end %>
  #     </div>
  #     <div class="-mt-px flex w-0 flex-1 justify-end">
  #       <a
  #         href={"?page=#{@meta.next_page}"}
  #         class="inline-flex items-center border-t-2 border-transparent pl-1 pt-4 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
  #       >
  #         Next
  #         <svg
  #           class="ml-3 h-5 w-5 text-gray-400"
  #           viewBox="0 0 20 20"
  #           fill="currentColor"
  #           aria-hidden="true"
  #           data-slot="icon"
  #         >
  #           <path
  #             fill-rule="evenodd"
  #             d="M2 10a.75.75 0 0 1 .75-.75h12.59l-2.1-1.95a.75.75 0 1 1 1.02-1.1l3.5 3.25a.75.75 0 0 1 0 1.1l-3.5 3.25a.75.75 0 1 1-1.02-1.1l2.1-1.95H2.75A.75.75 0 0 1 2 10Z"
  #             clip-rule="evenodd"
  #           />
  #         </svg>
  #       </a>
  #     </div>
  #   </nav>
  #   """
  # end

  def get_ranges(%Flop.Meta{total_pages: total_pages}) do
    cond do
      total_pages == 0 ->
        {:no_pages}

      total_pages < 7 ->
        {:no_elipses, Enum.to_list(1..total_pages), []}

      total_pages > 7 ->
        {:elipses, Enum.to_list(1..3), Enum.to_list((total_pages - 2)..total_pages)}
    end
  end

  def file_url(image) do
    static_path = Path.join(["media", image])
    Phoenix.VerifiedRoutes.static_url(VenieriWeb.Endpoint, "/" <> static_path)
  end
end
