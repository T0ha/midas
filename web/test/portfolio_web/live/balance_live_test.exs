defmodule PortfolioWeb.BalanceLiveTest do
  use PortfolioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Portfolio.BalancesFixtures

  @create_attrs %{amount: 120.5, date: "2022-12-5", locked: true, unlock_datetime: "2022-12-05T11:28:00Z"}
  @update_attrs %{amount: 456.7, date: "2022-12-6", locked: false, unlock_datetime: "2022-12-06T11:28:00Z"}
  @invalid_attrs %{amount: nil, date: nil, locked: false, unlock_datetime: nil}

  defp create_balance(_) do
    balance = balance_fixture()
    %{balance: balance}
  end

  describe "Index" do
    setup [:create_balance]

    test "lists all balances", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/balances")

      assert html =~ "Listing Balances"
    end

    test "saves new balance", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/balances")

      assert index_live |> element("a", "New Balance") |> render_click() =~
               "New Balance"

      assert_patch(index_live, ~p"/balances/new")

      assert index_live
             |> form("#balance-form", balance: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#balance-form", balance: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/balances")

      assert html =~ "Balance created successfully"
    end

    test "updates balance in listing", %{conn: conn, balance: balance} do
      {:ok, index_live, _html} = live(conn, ~p"/balances")

      assert index_live |> element("#balances-#{balance.id} a", "Edit") |> render_click() =~
               "Edit Balance"

      assert_patch(index_live, ~p"/balances/#{balance}/edit")

      assert index_live
             |> form("#balance-form", balance: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#balance-form", balance: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/balances")

      assert html =~ "Balance updated successfully"
    end

    test "deletes balance in listing", %{conn: conn, balance: balance} do
      {:ok, index_live, _html} = live(conn, ~p"/balances")

      assert index_live |> element("#balances-#{balance.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#balance-#{balance.id}")
    end
  end

  describe "Show" do
    setup [:create_balance]

    test "displays balance", %{conn: conn, balance: balance} do
      {:ok, _show_live, html} = live(conn, ~p"/balances/#{balance}")

      assert html =~ "Show Balance"
    end

    test "updates balance within modal", %{conn: conn, balance: balance} do
      {:ok, show_live, _html} = live(conn, ~p"/balances/#{balance}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Balance"

      assert_patch(show_live, ~p"/balances/#{balance}/show/edit")

      assert show_live
             |> form("#balance-form", balance: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#balance-form", balance: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/balances/#{balance}")

      assert html =~ "Balance updated successfully"
    end
  end
end
