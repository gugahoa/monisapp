defmodule MonisApp.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias MonisApp.Finance

  schema "transactions" do
    field :amount, :decimal
    field :note, :string
    field :payee, :string

    field :toggle, :boolean, default: false, virtual: true

    belongs_to :account, MonisApp.Finance.Account
    belongs_to :category, MonisApp.Finance.Category

    timestamps()
  end

  defp common_validation(changeset, attrs) do
    changeset
    |> cast(attrs, [:payee, :amount, :note, :account_id, :category_id])
    |> validate_required([:payee, :amount, :category_id, :account_id])
  end

  @doc false
  def changeset(transaction, user, attrs) do
    transaction
    |> common_validation(attrs)
    |> assoc_constraint(:account)
    |> assoc_constraint(:category)
    |> prepare_changes(fn changeset ->
      case Finance.get_account(user, get_field(changeset, :account_id)) do
        nil ->
          add_error(changeset, :account, "does not belong to user")

        _ ->
          changeset
      end
    end)
    |> prepare_changes(fn changeset ->
      case Finance.get_category(user, get_field(changeset, :category_id)) do
        nil ->
          add_error(changeset, :category, "does not belong to user")

        _ ->
          changeset
      end
    end)
  end

  @doc false
  def form_changeset(transaction, attrs) do
    transaction
    |> common_validation(attrs)
    |> cast(attrs, [:toggle])
    |> toggle_amount_signal()
  end

  defp toggle_amount_signal(changeset) do
    toggle = get_change(changeset, :toggle)
    amount = get_field(changeset, :amount) |> Decimal.abs()

    if toggle do
      changeset
      |> put_change(:amount, amount)
    else
      changeset
      |> put_change(:amount, Decimal.minus(amount))
    end
  end
end
