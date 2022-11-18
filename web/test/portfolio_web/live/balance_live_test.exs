defmodule PortfolioWeb.BalanceLiveTest do
  use PortfolioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Portfolio.BalancesFixtures

  @create_attrs %{amount: 120.5, locked: true, unlock_datetime: %{day: 17, hour: 13, minute: 27, month: 11, year: 2022}}
  @update_attrs %{amount: 456.7, locked: false, unlock_datetime: %{day: 18, hour: 13, minute: 27, month: 11, year: 2022}}
  @invalid_attrs %{amount: nil, locked: false, unlock_datetime: %{day: 30, hour: 13, minute: 27, month: 2, year: 2022}}

  defp create_balance(_) do
    balance = balance_fixture()
    %{balance: balance}
  end

  describe "Index" do
    setup [:create_balance]

    test "lists all balances", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.balance_index_path(conn, :index))

      assert html =~ "Listing Balances"
    end

    test "saves new balance", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.balance_index_path(conn, :index))

      assert index_live |> element("a", "New Balance") |> render_click() =~
               "New Balance"

      assert_patch(index_live, Routes.balance_index_path(conn, :new))

      assert index_live
             |> form("#balance-form", balance: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#balance-form", balance: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.balance_index_path(conn, :index))

      assert html =~ "Balance created successfully"
    end

    test "updates balance in listing", %{conn: conn, balance: balance} do
      {:ok, index_live, _html} = live(conn, Routes.balance_index_path(conn, :index))

      assert index_live |> element("#balance-#{balance.id} a", "Edit") |> render_click() =~
               "Edit Balance"

      assert_patch(index_live, Routes.balance_index_path(conn, :edit, balance))

      assert index_live
             |> form("#balance-form", balance: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#balance-form", balance: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.balance_index_path(conn, :index))

      assert html =~ "Balance updated successfully"
    end

    test "deletes balance in listing", %{conn: conn, balance: balance} do
      {:ok, index_live, _html} = live(conn, Routes.balance_index_path(conn, :index))

      assert index_live |> element("#balance-#{balance.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#balance-#{balance.id}")
    end
  end

  describe "Show" do
    setup [:create_balance]

    test "displays balance", %{conn: conn, balance: balance} do
      {:ok, _show_live, html} = live(conn, Routes.balance_show_path(conn, :show, balance))

      assert html =~ "Show Balance"
    end

    test "updates balance within modal", %{conn: conn, balance: balance} do
      {:ok, show_live, _html} = live(conn, Routes.balance_show_path(conn, :show, balance))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Balance"

      assert_patch(show_live, Routes.balance_show_path(conn, :edit, balance))

      assert show_live
             |> form("#balance-form", balance: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#balance-form", balance: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.balance_show_path(conn, :show, balance))

      assert html =~ "Balance updated successfully"
    end
  end
end
