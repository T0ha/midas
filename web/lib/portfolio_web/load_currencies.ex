defmodule PortfolioWeb.AssignCurrency do
  use PortfolioWeb, :verified_routes


  alias Portfolio.Assets

  def on_mount(:default, _params, _session, socket) do
    socket = 
      socket
      |> Phoenix.Component.assign_new(:currency, fn -> "usd" end)
      |> Phoenix.Component.assign(:currencies, Assets.list_currencies())

    {:cont, socket}
  end

  def change_currency(socket, %{"currency" => currency}), do:
    Phoenix.Component.assign(socket, :currency, currency)
end
