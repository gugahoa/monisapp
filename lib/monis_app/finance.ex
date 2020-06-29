defmodule MonisApp.Finance do
  @moduledoc """
  The Finance context.
  """

  import Ecto.Query, warn: false
  alias MonisApp.Repo

  alias MonisApp.Finance.Category
  alias MonisApp.Accounts.User

  @doc """
  Returns a list of default categories.

  ## Exampels

      iex> default_categories()
      [%Category{}, ...]

  """
  def default_categories do
    categories = [
      {"Income", "income", "Income"},
      {"Groceries", "expense", "Recurring Expenses"},
      {"Rent", "expense", "Recurring Expenses"},
      {"Internet", "expense", "Recurring Expenses"},
      {"Phone", "expense", "Recurring Expenses"},
      {"Health", "expense", "Recurring Expenses"},
      {"Dining Out", "expense", "For fun"}
    ]

    categories
    |> Stream.map(fn {name, type, group} ->
      Category.changeset(%Category{}, %{name: name, type: type, group: group})
    end)
    |> Enum.map(&Ecto.Changeset.apply_action!(&1, :validate))
  end

  @doc """
  Creates the default categories for a given user.

  ## Examples

      iex> create_default_categories(user)
      [%Category{}, ...]

  """
  def create_default_categories(%User{} = user) do
    Repo.transaction(fn ->
      default_categories()
      |> Stream.map(&Ecto.build_assoc(user, :categories, &1))
      |> Enum.map(&Repo.insert!/1)
    end)
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories(user)
      [%Category{}, ...]

  """
  def list_categories(user) do
    Category
    |> where([c], c.user_id == ^user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single category.

  ## Examples

      iex> get_category(user, 123)
      %Category{}

      iex> get_category(user, 456)
      nil

  """
  def get_category(%User{} = user, id), do: Repo.get_by(Category, id: id, user_id: user.id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(user, %{field: value})
      {:ok, %Category{}}

      iex> create_category(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:categories)
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  alias MonisApp.Finance.Account

  @doc """
  Returns the balance of all user's accounts.

  ## Examples

      iex> list_balances(user)
      [%{account: %Account{}, balance: #Decimal<15.45>}, ...]

  """
  def list_balances(user) do
    Account
    |> where([a], a.user_id == ^user.id)
    |> join(:left, [a], t in assoc(a, :transactions))
    |> select([a, t], %{
      account: a,
      balance: coalesce(sum(t.amount), 0) + a.starting_balance,
      last_transaction_date: max(t.date)
    })
    |> group_by([a], a.id)
    |> Repo.all()
  end

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts(%User{})
      [%Account{}, ...]

  """
  def list_accounts(%User{} = user) do
    Account
    |> where([a], a.user_id == ^user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single account.

  ## Examples

      iex> get_account(123)
      %Account{}

      iex> get_account(456)
      nil

  """
  def get_account(%User{} = user, id), do: Repo.get_by(Account, id: id, user_id: user.id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(user, %{field: value})
      {:ok, %Account{}}

      iex> create_account(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:accounts)
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  alias MonisApp.Finance.Transaction
  alias MonisApp.Accounts.User

  @doc """
  Returns the list of all payees for a user's transactions

  ## Examples

    iex> list_payees(user)
    ["7Eleven", ...]

  """
  def list_payees(%User{} = user) do
    Transaction
    |> join(:left, [t], a in assoc(t, :account))
    |> where([t, a], a.user_id == ^user.id)
    |> distinct([t], t.payee)
    |> select([t], t.payee)
    |> Repo.all()
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(user, %{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(%User{} = user, attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(user, attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(user, transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(user, transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%User{} = user, %Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(user, attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(user, transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%User{} = user, %Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, user, attrs)
  end
end
