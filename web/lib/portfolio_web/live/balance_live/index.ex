defmodule PortfolioWeb.BalanceLive.Index do
  use PortfolioWeb, :live_view

  alias Portfolio.Balances
  alias PortfolioWeb.AssignTopSelects

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :balances, list_balances(socket.assigns.current_user, socket.assigns.currency, socket.assigns['period']))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Balances")
    |> assign(:balance, nil)
  end

  @impl true
  def handle_event("change_selects", %{"currency" => currency, "period" => period} = params, socket) do
    {:noreply,
      socket
      |> AssignTopSelects.change_selects(params)
      |> assign(:balances, list_balances(socket.assigns.current_user, currency, period))
    }
  end

  defp list_balances(user, currency, nil), do: 
    list_balances(user, currency, "day")
  defp list_balances(user, currency, period) do
    Balances.list_balances_for_user(user.id, currency, period)
  end
end
