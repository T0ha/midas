defmodule PortfolioWeb.AssignTopSelects do
  use PortfolioWeb, :verified_routes


  alias Portfolio.Assets
  @periods ~w(day week month year)a

  def on_mount(:default, _params, _session, socket) do
    socket = 
      socket
      |> Phoenix.Component.assign_new(:currency, fn -> "usd" end)
      |> Phoenix.Component.assign(:currencies, Assets.list_currencies())
      |> Phoenix.Component.assign(:periods, @periods)
      |> Phoenix.Component.assign(:period, :day)

    {:cont, socket}
  end

  def change_selects(socket, %{
    "currency" => currency, 
    "period" => period
  }), do:
    socket
    |> Phoenix.Component.assign(:currency, currency)
    |> Phoenix.Component.assign(:period, period)
end
