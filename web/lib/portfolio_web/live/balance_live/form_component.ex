defmodule PortfolioWeb.BalanceLive.FormComponent do
  use PortfolioWeb, :live_component

  alias Portfolio.Balances

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage balance records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="balance-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :amount}} type="number" label="amount" step="any" />
        <.input field={{f, :locked}} type="checkbox" label="locked" />
        <.input field={{f, :unlock_datetime}} type="datetime-local" label="unlock_datetime" />
        <.input field={{f, :date}} type="date" label="date" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Balance</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{balance: balance} = assigns, socket) do
    changeset = Balances.change_balance(balance)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"balance" => balance_params}, socket) do
    changeset =
      socket.assigns.balance
      |> Balances.change_balance(balance_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"balance" => balance_params}, socket) do
    save_balance(socket, socket.assigns.action, balance_params)
  end

  defp save_balance(socket, :edit, balance_params) do
    case Balances.update_balance(socket.assigns.balance, balance_params) do
      {:ok, _balance} ->
        {:noreply,
         socket
         |> put_flash(:info, "Balance updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_balance(socket, :new, balance_params) do
    case Balances.create_balance(balance_params) do
      {:ok, _balance} ->
        {:noreply,
         socket
         |> put_flash(:info, "Balance created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
