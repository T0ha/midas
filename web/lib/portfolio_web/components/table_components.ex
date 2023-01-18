defmodule PortfolioWeb.TableComponents do
  @moduledoc """
  Provides smart table UI components.

  The components in this module use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn how to
  customize the generated components in this module.

  Icons are provided by [heroicons](https://heroicons.com), using the
  [heroicons_elixir](https://github.com/mveytsman/heroicons_elixir) project.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import PortfolioWeb.Gettext

  @doc ~S"""
  Renders a 2D table from 2 column ordered Ecto table with generic styling.

  ## Examples

      <.table_2d id="users" rows={@users} label>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table_2d>
  """
  attr :id, :string, required: true
  attr :cols, :list, required: true
  attr :rows, :list, required: true
  attr :default, :string, default: "ND"

  attr :col_field, :atom, required: true
  slot :col_header, required: true
  slot :col_data, required: true

  attr :group_field, :atom, default: :date
  slot :group_header
  slot :group_data


  #slot :action, doc: "the slot for showing user actions in the last table column"

  def table_2d(assigns) do
    assigns = Map.update!(assigns, :rows, fn rows ->
        Enum.chunk_by(rows, & Map.get(&1, assigns.group_field)) 
    end)

    ~H"""
    <div id={@id} class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="mt-11 w-[40rem] sm:w-full">
        <thead class="text-left text-[0.8125rem] leading-6 text-zinc-500">
          <tr>
            <th class="p-0 pb-4 pr-6 font-normal">
              <%= render_slot(@group_header) || "Date" %>
            </th>
            <th :for={col <- @cols} class="p-0 pb-4 pr-6 font-normal">
              <%= render_slot(@col_header, col) %>
              </th>
              </tr>
              </thead>

              <tbody class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700">
              <%= for row <- @rows do %>
              <tr
              id={"#{@id}-#{Map.get(hd(row), @group_field)}"}
              class="relative group hover:bg-zinc-50"
              >
              <td>
                <%= render_slot(@group_data, hd(row)) || (row |> hd()).date %>
              </td>
              <%= for col <- @cols do %>
              <td>
              <%= if Enum.any?(row, & Map.get(&1, @col_field) == col.id) do %>
              <%= render_slot(@col_data, Enum.find(row, & Map.get(&1, @col_field) == col.id)) %>
              <% else %>
              <%= @default %>
              <% end %>
            </td>
            <% end %>
          </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end
end
