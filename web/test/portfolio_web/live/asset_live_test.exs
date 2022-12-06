defmodule PortfolioWeb.AssetLiveTest do
  use PortfolioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Portfolio.AssetsFixtures

  @create_attrs %{fetch: true, gecko_id: "some gecko_id", name: "some name", ticker: "some ticker"}
  @update_attrs %{fetch: false, gecko_id: "some updated gecko_id", name: "some updated name", ticker: "some updated ticker"}
  @invalid_attrs %{fetch: false, gecko_id: nil, name: nil, ticker: nil}

  defp create_asset(_) do
    asset = asset_fixture()
    %{asset: asset}
  end

  describe "Index" do
    setup [:create_asset]

    test "lists all assets", %{conn: conn, asset: asset} do
      {:ok, _index_live, html} = live(conn, ~p"/assets")

      assert html =~ "Listing Assets"
      assert html =~ asset.gecko_id
    end

    test "saves new asset", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/assets")

      assert index_live |> element("a", "New Asset") |> render_click() =~
               "New Asset"

      assert_patch(index_live, ~p"/assets/new")

      assert index_live
             |> form("#asset-form", asset: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#asset-form", asset: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/assets")

      assert html =~ "Asset created successfully"
      assert html =~ "some gecko_id"
    end

    test "updates asset in listing", %{conn: conn, asset: asset} do
      {:ok, index_live, _html} = live(conn, ~p"/assets")

      assert index_live |> element("#assets-#{asset.id} a", "Edit") |> render_click() =~
               "Edit Asset"

      assert_patch(index_live, ~p"/assets/#{asset}/edit")

      assert index_live
             |> form("#asset-form", asset: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#asset-form", asset: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/assets")

      assert html =~ "Asset updated successfully"
      assert html =~ "some updated gecko_id"
    end

    test "deletes asset in listing", %{conn: conn, asset: asset} do
      {:ok, index_live, _html} = live(conn, ~p"/assets")

      assert index_live |> element("#assets-#{asset.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#asset-#{asset.id}")
    end
  end

  describe "Show" do
    setup [:create_asset]

    test "displays asset", %{conn: conn, asset: asset} do
      {:ok, _show_live, html} = live(conn, ~p"/assets/#{asset}")

      assert html =~ "Show Asset"
      assert html =~ asset.gecko_id
    end

    test "updates asset within modal", %{conn: conn, asset: asset} do
      {:ok, show_live, _html} = live(conn, ~p"/assets/#{asset}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Asset"

      assert_patch(show_live, ~p"/assets/#{asset}/show/edit")

      assert show_live
             |> form("#asset-form", asset: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#asset-form", asset: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/assets/#{asset}")

      assert html =~ "Asset updated successfully"
      assert html =~ "some updated gecko_id"
    end
  end
end
