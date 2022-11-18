defmodule PortfolioWeb.PriceLive.FormComponent do
  use PortfolioWeb, :live_component

  alias Portfolio.Assets

  @impl true
  def update(%{price: price} = assigns, socket) do
    changeset = Assets.change_price(price)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"price" => price_params}, socket) do
    changeset =
      socket.assigns.price
      |> Assets.change_price(price_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"price" => price_params}, socket) do
    save_price(socket, socket.assigns.action, price_params)
  end

  defp save_price(socket, :edit, price_params) do
    case Assets.update_price(socket.assigns.price, price_params) do
      {:ok, _price} ->
        {:noreply,
         socket
         |> put_flash(:info, "Price updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_price(socket, :new, price_params) do
    case Assets.create_price(price_params) do
      {:ok, _price} ->
        {:noreply,
         socket
         |> put_flash(:info, "Price created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
