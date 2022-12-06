defmodule PortfolioWeb.BalanceLive.Index do
  use PortfolioWeb, :live_view

  alias Portfolio.Balances
  alias Portfolio.Balances.Balance

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :balances, list_balances())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Balance")
    |> assign(:balance, Balances.get_balance!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Balance")
    |> assign(:balance, %Balance{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Balances")
    |> assign(:balance, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    balance = Balances.get_balance!(id)
    {:ok, _} = Balances.delete_balance(balance)

    {:noreply, assign(socket, :balances, list_balances())}
  end

  defp list_balances do
    Balances.list_balances()
  end
end
