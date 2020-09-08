defmodule MonisApp.FinanceTest do
  use MonisApp.DataCase

  alias MonisApp.Finance

  describe "category" do
    alias MonisApp.Finance.Category

    test "default_categories/0 returns list of default categories with no errors" do
      categories = Finance.default_categories()
      Enum.map(categories, &assert(%Category{} = &1))
    end

    test "create_default_categories/1 creates the default categories for a given user" do
      user = insert(:user)

      default_categories = Finance.default_categories()
      assert {:ok, categories} = Finance.create_default_categories(user)
      assert length(default_categories) == length(categories)
    end
  end

  describe "payees" do
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

  describe "transaciton" do
    alias MonisApp.Finance.Transaction

    test "create_transaction/2 with account and category not belonging to user returns an error" do
      account = insert(:account)
      category = insert(:category)

      user = build(:user) |> set_user_password("some password") |> insert

      assert {:error, %Ecto.Changeset{} = changeset} =
               Finance.create_transaction(user, %{
                 account_id: account.id,
                 category_id: category.id,
                 payee: "test",
                 amount: 10,
                 date: Date.utc_today()
               })

      assert "does not belong to user" in errors_on(changeset).category
      assert "does not belong to user" in errors_on(changeset).account
    end

    test "create_transaction/2 with valid data correctly creates transaction" do
      user = build(:user) |> set_user_password("some password") |> insert

      account = insert(:account, user: user)
      category = insert(:category, user: user)

      assert {:ok, %Transaction{}} =
               Finance.create_transaction(user, %{
                 account_id: account.id,
                 category_id: category.id,
                 payee: "example",
                 amount: 10,
                 date: Date.utc_today()
               })
    end

    test "change_transaction/2 correctly creates changeset for transaction" do
      user = build(:user) |> set_user_password("some password") |> insert
      assert %Ecto.Changeset{} = Finance.change_transaction(user, %Transaction{})
    end
  end

  describe "balances" do
    test "list_balances/1 returns empty list when there's no accounts" do
      assert [] == Finance.list_balances(insert(:user))
    end

    test "list_balances/1 when there's no transaction returns balance 0" do
      user = insert(:user)
      account_id = insert(:account, user: user).id

      zero = Decimal.new(0)
      assert [%{account: %{id: ^account_id}, balance: ^zero}] = Finance.list_balances(user)
    end

    test "list_balances/1 returns a list with accounts, their balance and last transaction date" do
      user = insert(:user)
      account = insert(:account, user: user)

      insert(:transaction,
        account: account,
        amount: -7_000,
        date: ~D[2020-06-21],
        inserted_at: ~N[2020-06-22 18:00:00]
      )

      insert(:transaction,
        account: account,
        amount: 15_000,
        date: ~D[2020-06-20],
        inserted_at: ~N[2020-06-22 19:00:00]
      )

      balance = Decimal.new(8_000)
      account_id = account.id

      assert [
               %{
                 account: %{id: ^account_id},
                 balance: ^balance,
                 last_transaction_date: ~N[2020-06-22 19:00:00]
               }
             ] = Finance.list_balances(user)
    end

    test "list_balances/1 takes into consideration starting balance" do
      user = insert(:user)
      account = insert(:account, user: user, starting_balance: 1_000)

      insert(:transaction, account: account, amount: 15_000)
      balance = Decimal.new(16_000)
      account_id = account.id
      assert [%{account: %{id: ^account_id}, balance: ^balance}] = Finance.list_balances(user)
    end
  end
end
