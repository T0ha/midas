defmodule PortfolioWeb.PriceLive.Index do
  use PortfolioWeb, :live_view

  alias Portfolio.Assets

  @impl true
  def mount(_params, _session, socket) do
    assets = Assets.list_user_assets(1)
    {:ok,
      socket
      |> assign(:assets, assets)
      |> assign(:currencies, Assets.list_currencies())
      |> assign(:prices, list_prices(socket.assigns['currency'], Enum.map(assets, & &1.id)))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Prices")
    |> assign(:price, nil)
  end

  @impl true
  def handle_event("change_currency", %{"currency" => currency}, socket) do
    {:noreply,
      socket
      |> assign(:currency, currency)
      |> assign(:prices, list_prices(currency, Enum.map(socket.assigns.assets, & &1.id)))
    }
    end

  defp list_prices(currency \\ "usd", assets \\ [])
  defp list_prices(nil, assets), do: list_prices("usd", assets)
  defp list_prices(currency, assets) do
    currency
    |> Assets.list_prices(assets)
  end
end
