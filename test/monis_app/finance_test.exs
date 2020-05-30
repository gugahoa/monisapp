defmodule MonisApp.FinanceTest do
  use MonisApp.DataCase

  alias MonisApp.Finance

  describe "category" do
    alias MonisApp.Finance.Category

    test "default_categories/0 returns list of default categories with no errors" do
      categories = Finance.default_categories()
      Enum.map(categories, &assert %Category{} = &1)
    end

    test "create_default_categories/1 creates the default categories for a given user" do
      user = insert(:user)

      default_categories = Finance.default_categories()
      assert {:ok, categories} = Finance.create_default_categories(user)
      assert length(default_categories) == length(categories)
    end
  end

  describe "payees" do
    alias MonisApp.Finance.Transaction

    test "list_payees/1 returns all distinct payees for a given user" do
      user = insert(:user)
      assert [] == Finance.list_payees(user)

      account = insert(:account, user: user)
      insert(:transaction, account: account, payee: "something")
      insert(:transaction, account: account, payee: "something")
      insert(:transaction, account: account, payee: "something other")
      assert ["something", "something other"] == Finance.list_payees(user)
    end

    test "list_payees/2 does not return payees from other users" do
      user = insert(:user)
      insert(:transaction)

      assert [] == Finance.list_payees(user)
    end
  end
end
