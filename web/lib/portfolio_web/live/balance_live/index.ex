defmodule PortfolioWeb.BalanceLive.Index do
  use PortfolioWeb, :live_view

  alias Portfolio.Balances
  alias PortfolioWeb.AssignCurrency

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :balances, list_balances(socket.assigns.current_user, socket.assigns.currency))}
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
  def handle_event("change_currency", %{"currency" => currency} = params, socket) do
    {:noreply,
      socket
      |> AssignCurrency.change_currency(params)
      |> assign(:balances, list_balances(socket.assigns.current_user, currency))
    }
  end

  defp list_balances(user, currency) do
    Balances.list_balances_for_user(user.id, currency)
  end
end
