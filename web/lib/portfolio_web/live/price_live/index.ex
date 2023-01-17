defmodule PortfolioWeb.PriceLive.Index do
  use PortfolioWeb, :live_view

  alias Portfolio.Assets
  alias PortfolioWeb.AssignCurrency

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:prices, list_prices(socket.assigns['currency'], socket.assigns.current_user_assets))
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
  def handle_event("change_currency", %{"currency" => currency} = params, socket) do
    {:noreply,
      socket
      |> AssignCurrency.change_currency(params)
      |> assign(:prices, list_prices(currency, socket.assigns.current_user_assets))
    }
    end

  defp list_prices(currency \\ "usd", assets \\ [])
  defp list_prices(nil, assets), do: list_prices("usd", assets)
  defp list_prices(currency, assets) do
    currency
    |> Assets.list_prices(assets)
  end
end
