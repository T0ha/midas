defmodule PortfolioWeb.PriceLive.Index do
  use PortfolioWeb, :live_view

  alias Portfolio.Assets
  alias Portfolio.Assets.Price

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :prices, list_prices())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Price")
    |> assign(:price, Assets.get_price!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Price")
    |> assign(:price, %Price{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Prices")
    |> assign(:price, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    price = Assets.get_price!(id)
    {:ok, _} = Assets.delete_price(price)

    {:noreply, assign(socket, :prices, list_prices())}
  end

  defp list_prices do
    Assets.list_prices()
  end
end
