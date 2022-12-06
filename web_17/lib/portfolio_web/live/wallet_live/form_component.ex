defmodule PortfolioWeb.WalletLive.FormComponent do
  use PortfolioWeb, :live_component

  alias Portfolio.Wallets

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage wallet records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="wallet-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <.input
          field={{f, :type}}
          type="select"
          label="type"
          prompt="Choose a value"
          options={Ecto.Enum.values(Portfolio.Wallets.Wallet, :type)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Wallet</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{wallet: wallet} = assigns, socket) do
    changeset = Wallets.change_wallet(wallet)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"wallet" => wallet_params}, socket) do
    changeset =
      socket.assigns.wallet
      |> Wallets.change_wallet(wallet_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"wallet" => wallet_params}, socket) do
    save_wallet(socket, socket.assigns.action, wallet_params)
  end

  defp save_wallet(socket, :edit, wallet_params) do
    case Wallets.update_wallet(socket.assigns.wallet, wallet_params) do
      {:ok, _wallet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Wallet updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_wallet(socket, :new, wallet_params) do
    case Wallets.create_wallet(wallet_params) do
      {:ok, _wallet} ->
        {:noreply,
         socket
         |> put_flash(:info, "Wallet created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
