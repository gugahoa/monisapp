defmodule MonisApp.Factory do
  use ExMachina.Ecto, repo: MonisApp.Repo

  alias MonisApp.Accounts
  alias MonisApp.Accounts.User

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def user_factory() do
    %User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      confirmed_at: NaiveDateTime.utc_now()
    }
  end

  def set_user_password(user, password) do
    user
    |> Accounts.change_user_password(%{password: password, password_confirmation: password})
    |> Ecto.Changeset.apply_action!(:insert)
  end

  alias MonisApp.Finance.{Transaction, Category, Account}

  def account_factory() do
    %Account{
      name: sequence(:name, &"name-#{&1}"),
      user: build(:user),
      type: "checking"
    }
  end

  def category_factory() do
    %Category{
      name: sequence(:name, &"name-#{&1}"),
      type: "expense",
      group: "Expenses"
    }
  end

  def transaction_factory() do
    %Transaction{
      payee: sequence(:payee, &"Payee #{&1}"),
      note: "Some note",
      account: build(:account),
      category: build(:category)
    }
  end
end
