defmodule Portfolio.WalletsTest do
  use Portfolio.DataCase

  alias Portfolio.Wallets

  describe "wallets" do
    alias Portfolio.Wallets.Wallet

    import Portfolio.WalletsFixtures

    @invalid_attrs %{name: nil, subwallet: nil, type: nil}

    test "list_wallets/0 returns all wallets" do
      wallet = wallet_fixture()
      assert Wallets.list_wallets() == [wallet]
    end

    test "get_wallet!/1 returns the wallet with given id" do
      wallet = wallet_fixture()
      assert Wallets.get_wallet!(wallet.id) == wallet
    end

    test "create_wallet/1 with valid data creates a wallet" do
      valid_attrs = %{name: "some name", subwallet: "some subwallet", type: 42}

      assert {:ok, %Wallet{} = wallet} = Wallets.create_wallet(valid_attrs)
      assert wallet.name == "some name"
      assert wallet.subwallet == "some subwallet"
      assert wallet.type == 42
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallets.create_wallet(@invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet" do
      wallet = wallet_fixture()
      update_attrs = %{name: "some updated name", subwallet: "some updated subwallet", type: 43}

      assert {:ok, %Wallet{} = wallet} = Wallets.update_wallet(wallet, update_attrs)
      assert wallet.name == "some updated name"
      assert wallet.subwallet == "some updated subwallet"
      assert wallet.type == 43
    end

    test "update_wallet/2 with invalid data returns error changeset" do
      wallet = wallet_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallets.update_wallet(wallet, @invalid_attrs)
      assert wallet == Wallets.get_wallet!(wallet.id)
    end

    test "delete_wallet/1 deletes the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{}} = Wallets.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Wallets.get_wallet!(wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = wallet_fixture()
      assert %Ecto.Changeset{} = Wallets.change_wallet(wallet)
    end
  end
end
