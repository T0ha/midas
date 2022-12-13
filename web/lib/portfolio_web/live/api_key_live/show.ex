defmodule PortfolioWeb.ApiKeyLive.Show do
  use PortfolioWeb, :live_view

  alias Portfolio.Acounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:api_key, Acounts.get_api_key!(id))}
  end

  defp page_title(:show), do: "Show Api key"
  defp page_title(:edit), do: "Edit Api key"
end
