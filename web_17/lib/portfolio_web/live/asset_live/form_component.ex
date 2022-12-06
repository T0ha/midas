defmodule PortfolioWeb.AssetLive.FormComponent do
  use PortfolioWeb, :live_component

  alias Portfolio.Assets

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage asset records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="asset-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <.input field={{f, :ticker}} type="text" label="ticker" />
        <.input field={{f, :gecko_id}} type="text" label="gecko_id" />
        <.input field={{f, :fetch}} type="checkbox" label="fetch" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Asset</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{asset: asset} = assigns, socket) do
    changeset = Assets.change_asset(asset)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"asset" => asset_params}, socket) do
    changeset =
      socket.assigns.asset
      |> Assets.change_asset(asset_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"asset" => asset_params}, socket) do
    save_asset(socket, socket.assigns.action, asset_params)
  end

  defp save_asset(socket, :edit, asset_params) do
    case Assets.update_asset(socket.assigns.asset, asset_params) do
      {:ok, _asset} ->
        {:noreply,
         socket
         |> put_flash(:info, "Asset updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_asset(socket, :new, asset_params) do
    case Assets.create_asset(asset_params) do
      {:ok, _asset} ->
        {:noreply,
         socket
         |> put_flash(:info, "Asset created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
