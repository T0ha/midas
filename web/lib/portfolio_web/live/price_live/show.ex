defmodule PortfolioWeb.PriceLive.Show do
  use PortfolioWeb, :live_view

  alias Portfolio.Assets

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:price, Assets.get_price!(id))}
  end

  defp page_title(:show), do: "Show Price"
  defp page_title(:edit), do: "Edit Price"
end
