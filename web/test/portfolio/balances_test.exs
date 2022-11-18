defmodule Portfolio.BalancesTest do
  use Portfolio.DataCase

  alias Portfolio.Balances

  describe "balances" do
    alias Portfolio.Balances.Balance

    import Portfolio.BalancesFixtures

    @invalid_attrs %{amount: nil, locked: nil, unlock_datetime: nil}

    test "list_balances/0 returns all balances" do
      balance = balance_fixture()
      assert Balances.list_balances() == [balance]
    end

    test "get_balance!/1 returns the balance with given id" do
      balance = balance_fixture()
      assert Balances.get_balance!(balance.id) == balance
    end

    test "create_balance/1 with valid data creates a balance" do
      valid_attrs = %{amount: 120.5, locked: true, unlock_datetime: ~U[2022-11-17 13:27:00Z]}

      assert {:ok, %Balance{} = balance} = Balances.create_balance(valid_attrs)
      assert balance.amount == 120.5
      assert balance.locked == true
      assert balance.unlock_datetime == ~U[2022-11-17 13:27:00Z]
    end

    test "create_balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Balances.create_balance(@invalid_attrs)
    end

    test "update_balance/2 with valid data updates the balance" do
      balance = balance_fixture()
      update_attrs = %{amount: 456.7, locked: false, unlock_datetime: ~U[2022-11-18 13:27:00Z]}

      assert {:ok, %Balance{} = balance} = Balances.update_balance(balance, update_attrs)
      assert balance.amount == 456.7
      assert balance.locked == false
      assert balance.unlock_datetime == ~U[2022-11-18 13:27:00Z]
    end

    test "update_balance/2 with invalid data returns error changeset" do
      balance = balance_fixture()
      assert {:error, %Ecto.Changeset{}} = Balances.update_balance(balance, @invalid_attrs)
      assert balance == Balances.get_balance!(balance.id)
    end

    test "delete_balance/1 deletes the balance" do
      balance = balance_fixture()
      assert {:ok, %Balance{}} = Balances.delete_balance(balance)
      assert_raise Ecto.NoResultsError, fn -> Balances.get_balance!(balance.id) end
    end

    test "change_balance/1 returns a balance changeset" do
      balance = balance_fixture()
      assert %Ecto.Changeset{} = Balances.change_balance(balance)
    end
  end
end
