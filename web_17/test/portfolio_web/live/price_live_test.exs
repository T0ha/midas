defmodule PortfolioWeb.PriceLiveTest do
  use PortfolioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Portfolio.AssetsFixtures

  @create_attrs %{currency: "some currency", date: "2022-12-5", price: 120.5}
  @update_attrs %{currency: "some updated currency", date: "2022-12-6", price: 456.7}
  @invalid_attrs %{currency: nil, date: nil, price: nil}

  defp create_price(_) do
    price = price_fixture()
    %{price: price}
  end

  describe "Index" do
    setup [:create_price]

    test "lists all prices", %{conn: conn, price: price} do
      {:ok, _index_live, html} = live(conn, ~p"/prices")

      assert html =~ "Listing Prices"
      assert html =~ price.currency
    end

    test "saves new price", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/prices")

      assert index_live |> element("a", "New Price") |> render_click() =~
               "New Price"

      assert_patch(index_live, ~p"/prices/new")

      assert index_live
             |> form("#price-form", price: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#price-form", price: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/prices")

      assert html =~ "Price created successfully"
      assert html =~ "some currency"
    end

    test "updates price in listing", %{conn: conn, price: price} do
      {:ok, index_live, _html} = live(conn, ~p"/prices")

      assert index_live |> element("#prices-#{price.id} a", "Edit") |> render_click() =~
               "Edit Price"

      assert_patch(index_live, ~p"/prices/#{price}/edit")

      assert index_live
             |> form("#price-form", price: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#price-form", price: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/prices")

      assert html =~ "Price updated successfully"
      assert html =~ "some updated currency"
    end

    test "deletes price in listing", %{conn: conn, price: price} do
      {:ok, index_live, _html} = live(conn, ~p"/prices")

      assert index_live |> element("#prices-#{price.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#price-#{price.id}")
    end
  end

  describe "Show" do
    setup [:create_price]

    test "displays price", %{conn: conn, price: price} do
      {:ok, _show_live, html} = live(conn, ~p"/prices/#{price}")

      assert html =~ "Show Price"
      assert html =~ price.currency
    end

    test "updates price within modal", %{conn: conn, price: price} do
      {:ok, show_live, _html} = live(conn, ~p"/prices/#{price}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Price"

      assert_patch(show_live, ~p"/prices/#{price}/show/edit")

      assert show_live
             |> form("#price-form", price: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#price-form", price: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/prices/#{price}")

      assert html =~ "Price updated successfully"
      assert html =~ "some updated currency"
    end
  end
end
