defmodule PortfolioWeb.BalanceLive.FormComponent do
  use PortfolioWeb, :live_component

  alias Portfolio.Balances

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
         |> push_redirect(to: socket.assigns.return_to)}

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
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
