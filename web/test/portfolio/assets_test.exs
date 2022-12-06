defmodule Portfolio.AssetsTest do
  use Portfolio.DataCase

  alias Portfolio.Assets

  describe "assets" do
    alias Portfolio.Assets.Asset

    import Portfolio.AssetsFixtures

    @invalid_attrs %{fetch: nil, gecko_id: nil, name: nil, ticker: nil}

    test "list_assets/0 returns all assets" do
      asset = asset_fixture()
      assert Assets.list_assets() == [asset]
    end

    test "get_asset!/1 returns the asset with given id" do
      asset = asset_fixture()
      assert Assets.get_asset!(asset.id) == asset
    end

    test "create_asset/1 with valid data creates a asset" do
      valid_attrs = %{fetch: true, gecko_id: "some gecko_id", name: "some name", ticker: "some ticker"}

      assert {:ok, %Asset{} = asset} = Assets.create_asset(valid_attrs)
      assert asset.fetch == true
      assert asset.gecko_id == "some gecko_id"
      assert asset.name == "some name"
      assert asset.ticker == "some ticker"
    end

    test "create_asset/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assets.create_asset(@invalid_attrs)
    end

    test "update_asset/2 with valid data updates the asset" do
      asset = asset_fixture()
      update_attrs = %{fetch: false, gecko_id: "some updated gecko_id", name: "some updated name", ticker: "some updated ticker"}

      assert {:ok, %Asset{} = asset} = Assets.update_asset(asset, update_attrs)
      assert asset.fetch == false
      assert asset.gecko_id == "some updated gecko_id"
      assert asset.name == "some updated name"
      assert asset.ticker == "some updated ticker"
    end

    test "update_asset/2 with invalid data returns error changeset" do
      asset = asset_fixture()
      assert {:error, %Ecto.Changeset{}} = Assets.update_asset(asset, @invalid_attrs)
      assert asset == Assets.get_asset!(asset.id)
    end

    test "delete_asset/1 deletes the asset" do
      asset = asset_fixture()
      assert {:ok, %Asset{}} = Assets.delete_asset(asset)
      assert_raise Ecto.NoResultsError, fn -> Assets.get_asset!(asset.id) end
    end

    test "change_asset/1 returns a asset changeset" do
      asset = asset_fixture()
      assert %Ecto.Changeset{} = Assets.change_asset(asset)
    end
  end

  describe "prices" do
    alias Portfolio.Assets.Price

    import Portfolio.AssetsFixtures

    @invalid_attrs %{currency: nil, date: nil, price: nil}

    test "list_prices/0 returns all prices" do
      price = price_fixture()
      assert Assets.list_prices() == [price]
    end

    test "get_price!/1 returns the price with given id" do
      price = price_fixture()
      assert Assets.get_price!(price.id) == price
    end

    test "create_price/1 with valid data creates a price" do
      valid_attrs = %{currency: "some currency", date: ~D[2022-12-05], price: 120.5}

      assert {:ok, %Price{} = price} = Assets.create_price(valid_attrs)
      assert price.currency == "some currency"
      assert price.date == ~D[2022-12-05]
      assert price.price == 120.5
    end

    test "create_price/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assets.create_price(@invalid_attrs)
    end

    test "update_price/2 with valid data updates the price" do
      price = price_fixture()
      update_attrs = %{currency: "some updated currency", date: ~D[2022-12-06], price: 456.7}

      assert {:ok, %Price{} = price} = Assets.update_price(price, update_attrs)
      assert price.currency == "some updated currency"
      assert price.date == ~D[2022-12-06]
      assert price.price == 456.7
    end

    test "update_price/2 with invalid data returns error changeset" do
      price = price_fixture()
      assert {:error, %Ecto.Changeset{}} = Assets.update_price(price, @invalid_attrs)
      assert price == Assets.get_price!(price.id)
    end

    test "delete_price/1 deletes the price" do
      price = price_fixture()
      assert {:ok, %Price{}} = Assets.delete_price(price)
      assert_raise Ecto.NoResultsError, fn -> Assets.get_price!(price.id) end
    end

    test "change_price/1 returns a price changeset" do
      price = price_fixture()
      assert %Ecto.Changeset{} = Assets.change_price(price)
    end
  end
end
