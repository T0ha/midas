defmodule PortfolioWeb.PriceLiveTest do
  use PortfolioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Portfolio.AssetsFixtures

  @create_attrs %{date: %{day: 17, month: 11, year: 2022}, price: 120.5}
  @update_attrs %{date: %{day: 18, month: 11, year: 2022}, price: 456.7}
  @invalid_attrs %{date: %{day: 30, month: 2, year: 2022}, price: nil}

  defp create_price(_) do
    price = price_fixture()
    %{price: price}
  end

  describe "Index" do
    setup [:create_price]

    test "lists all prices", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.price_index_path(conn, :index))

      assert html =~ "Listing Prices"
    end

    test "saves new price", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.price_index_path(conn, :index))

      assert index_live |> element("a", "New Price") |> render_click() =~
               "New Price"

      assert_patch(index_live, Routes.price_index_path(conn, :new))

      assert index_live
             |> form("#price-form", price: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#price-form", price: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.price_index_path(conn, :index))

      assert html =~ "Price created successfully"
    end

    test "updates price in listing", %{conn: conn, price: price} do
      {:ok, index_live, _html} = live(conn, Routes.price_index_path(conn, :index))

      assert index_live |> element("#price-#{price.id} a", "Edit") |> render_click() =~
               "Edit Price"

      assert_patch(index_live, Routes.price_index_path(conn, :edit, price))

      assert index_live
             |> form("#price-form", price: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#price-form", price: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.price_index_path(conn, :index))

      assert html =~ "Price updated successfully"
    end

    test "deletes price in listing", %{conn: conn, price: price} do
      {:ok, index_live, _html} = live(conn, Routes.price_index_path(conn, :index))

      assert index_live |> element("#price-#{price.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#price-#{price.id}")
    end
  end

  describe "Show" do
    setup [:create_price]

    test "displays price", %{conn: conn, price: price} do
      {:ok, _show_live, html} = live(conn, Routes.price_show_path(conn, :show, price))

      assert html =~ "Show Price"
    end

    test "updates price within modal", %{conn: conn, price: price} do
      {:ok, show_live, _html} = live(conn, Routes.price_show_path(conn, :show, price))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Price"

      assert_patch(show_live, Routes.price_show_path(conn, :edit, price))

      assert show_live
             |> form("#price-form", price: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#price-form", price: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.price_show_path(conn, :show, price))

      assert html =~ "Price updated successfully"
    end
  end
end
