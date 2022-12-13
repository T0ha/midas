defmodule PortfolioWeb.ApiKeyLiveTest do
  use PortfolioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Portfolio.AcountsFixtures

  @create_attrs %{key: "some key", secret: "some secret"}
  @update_attrs %{key: "some updated key", secret: "some updated secret"}
  @invalid_attrs %{key: nil, secret: nil}

  defp create_api_key(_) do
    api_key = api_key_fixture()
    %{api_key: api_key}
  end

  describe "Index" do
    setup [:create_api_key]

    test "lists all api_keys", %{conn: conn, api_key: api_key} do
      {:ok, _index_live, html} = live(conn, ~p"/api_keys")

      assert html =~ "Listing Api keys"
      assert html =~ api_key.key
    end

    test "saves new api_key", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/api_keys")

      assert index_live |> element("a", "New Api key") |> render_click() =~
               "New Api key"

      assert_patch(index_live, ~p"/api_keys/new")

      assert index_live
             |> form("#api_key-form", api_key: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#api_key-form", api_key: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/api_keys")

      assert html =~ "Api key created successfully"
      assert html =~ "some key"
    end

    test "updates api_key in listing", %{conn: conn, api_key: api_key} do
      {:ok, index_live, _html} = live(conn, ~p"/api_keys")

      assert index_live |> element("#api_keys-#{api_key.id} a", "Edit") |> render_click() =~
               "Edit Api key"

      assert_patch(index_live, ~p"/api_keys/#{api_key}/edit")

      assert index_live
             |> form("#api_key-form", api_key: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#api_key-form", api_key: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/api_keys")

      assert html =~ "Api key updated successfully"
      assert html =~ "some updated key"
    end

    test "deletes api_key in listing", %{conn: conn, api_key: api_key} do
      {:ok, index_live, _html} = live(conn, ~p"/api_keys")

      assert index_live |> element("#api_keys-#{api_key.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#api_key-#{api_key.id}")
    end
  end

  describe "Show" do
    setup [:create_api_key]

    test "displays api_key", %{conn: conn, api_key: api_key} do
      {:ok, _show_live, html} = live(conn, ~p"/api_keys/#{api_key}")

      assert html =~ "Show Api key"
      assert html =~ api_key.key
    end

    test "updates api_key within modal", %{conn: conn, api_key: api_key} do
      {:ok, show_live, _html} = live(conn, ~p"/api_keys/#{api_key}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Api key"

      assert_patch(show_live, ~p"/api_keys/#{api_key}/show/edit")

      assert show_live
             |> form("#api_key-form", api_key: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#api_key-form", api_key: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/api_keys/#{api_key}")

      assert html =~ "Api key updated successfully"
      assert html =~ "some updated key"
    end
  end
end
