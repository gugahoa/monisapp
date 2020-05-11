defmodule MonisApp.FinanceTest do
  use MonisApp.DataCase

  alias MonisApp.Finance

  def user_fixture() do
    {:ok, user} =
      MonisApp.Accounts.register_user(%{email: "gustavo@email.com", password: "some_password"})

    user
  end

  describe "categories" do
    alias MonisApp.Finance.Category

    @valid_attrs %{hidden: true, name: "some name", type: "expense"}
    @update_attrs %{hidden: false, name: "some updated name", type: "income"}
    @invalid_attrs %{hidden: nil, name: nil, type: nil}

    def category_fixture(attrs \\ %{}) do
      attrs =
        attrs
        |> Enum.into(@valid_attrs)

      {:ok, category} =
        user_fixture()
        |> Finance.create_category(attrs)

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Finance.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Finance.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      user = user_fixture()
      assert {:ok, %Category{} = category} = Finance.create_category(user, @valid_attrs)
      assert category.hidden == true
      assert category.name == "some name"
      assert category.type == "expense"
    end

    test "create_category/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.create_category(user, @invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Finance.update_category(category, @update_attrs)
      assert category.hidden == false
      assert category.name == "some updated name"
      assert category.type == "income"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_category(category, @invalid_attrs)
      assert category == Finance.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Finance.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Finance.change_category(category)
    end
  end

  describe "accounts" do
    alias MonisApp.Finance.Account

    @valid_attrs %{amount: "120.5", is_active: true, type: "some type"}
    @update_attrs %{amount: "456.7", is_active: false, type: "some updated type"}
    @invalid_attrs %{amount: nil, is_active: nil, type: nil}

    def account_fixture(attrs \\ %{}) do
      attrs =
        attrs
        |> Enum.into(@valid_attrs)
      {:ok, account} =
        user_fixture()
        |> Finance.create_account(attrs)

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Finance.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Finance.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Finance.create_account(@valid_attrs)
      assert account.amount == Decimal.new("120.5")
      assert account.is_active == true
      assert account.type == "some type"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Finance.update_account(account, @update_attrs)
      assert account.amount == Decimal.new("456.7")
      assert account.is_active == false
      assert account.type == "some updated type"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_account(account, @invalid_attrs)
      assert account == Finance.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Finance.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Finance.change_account(account)
    end
  end
end
