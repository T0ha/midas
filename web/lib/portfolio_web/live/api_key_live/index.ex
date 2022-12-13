defmodule PortfolioWeb.ApiKeyLive.Index do
  use PortfolioWeb, :live_view

  alias Portfolio.Acounts
  alias Portfolio.Acounts.ApiKey

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :api_keys, list_api_keys())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Api key")
    |> assign(:api_key, Acounts.get_api_key!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Api key")
    |> assign(:api_key, %ApiKey{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Api keys")
    |> assign(:api_key, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    api_key = Acounts.get_api_key!(id)
    {:ok, _} = Acounts.delete_api_key(api_key)

    {:noreply, assign(socket, :api_keys, list_api_keys())}
  end

  defp list_api_keys do
    Acounts.list_api_keys()
  end
end
