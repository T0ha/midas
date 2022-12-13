defmodule Portfolio.AcountsTest do
  use Portfolio.DataCase

  alias Portfolio.Acounts

  describe "api_keys" do
    alias Portfolio.Acounts.ApiKey

    import Portfolio.AcountsFixtures

    @invalid_attrs %{key: nil, secret: nil}

    test "list_api_keys/0 returns all api_keys" do
      api_key = api_key_fixture()
      assert Acounts.list_api_keys() == [api_key]
    end

    test "get_api_key!/1 returns the api_key with given id" do
      api_key = api_key_fixture()
      assert Acounts.get_api_key!(api_key.id) == api_key
    end

    test "create_api_key/1 with valid data creates a api_key" do
      valid_attrs = %{key: "some key", secret: "some secret"}

      assert {:ok, %ApiKey{} = api_key} = Acounts.create_api_key(valid_attrs)
      assert api_key.key == "some key"
      assert api_key.secret == "some secret"
    end

    test "create_api_key/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Acounts.create_api_key(@invalid_attrs)
    end

    test "update_api_key/2 with valid data updates the api_key" do
      api_key = api_key_fixture()
      update_attrs = %{key: "some updated key", secret: "some updated secret"}

      assert {:ok, %ApiKey{} = api_key} = Acounts.update_api_key(api_key, update_attrs)
      assert api_key.key == "some updated key"
      assert api_key.secret == "some updated secret"
    end

    test "update_api_key/2 with invalid data returns error changeset" do
      api_key = api_key_fixture()
      assert {:error, %Ecto.Changeset{}} = Acounts.update_api_key(api_key, @invalid_attrs)
      assert api_key == Acounts.get_api_key!(api_key.id)
    end

    test "delete_api_key/1 deletes the api_key" do
      api_key = api_key_fixture()
      assert {:ok, %ApiKey{}} = Acounts.delete_api_key(api_key)
      assert_raise Ecto.NoResultsError, fn -> Acounts.get_api_key!(api_key.id) end
    end

    test "change_api_key/1 returns a api_key changeset" do
      api_key = api_key_fixture()
      assert %Ecto.Changeset{} = Acounts.change_api_key(api_key)
    end
  end
end
