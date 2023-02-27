defmodule PortfolioWeb.PriceLive.Index do
  use PortfolioWeb, :live_view

  alias Portfolio.Assets
  alias PortfolioWeb.AssignTopSelects

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:prices, list_prices(socket.assigns['currency'], socket.assigns['period'], socket.assigns.current_user_assets))
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
  def handle_event("change_selects", %{"currency" => currency, "period" => period} = params, socket) do
    {:noreply,
      socket
      |> AssignTopSelects.change_selects(params)
      |> assign(:prices, list_prices(currency, period, socket.assigns.current_user_assets))
    }
    end

  defp list_prices(currency \\ "usd", period \\ "day", assets \\ [])
  defp list_prices(nil, nil, assets), do: list_prices("usd", "day", assets)
  defp list_prices(currency, period, assets), do:
    Assets.list_prices(currency, period, assets)
end
