defmodule PortfolioWeb.BalanceLive.Index do
  use PortfolioWeb, :live_view

  alias Portfolio.Balances
  alias Portfolio.Balances.Balance

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :balances, list_balances(socket.assigns.current_user))}
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

  defp list_balances(user) do
    Balances.list_balances_for_user(user.id)
  end
end
