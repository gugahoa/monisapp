defmodule MonisApp.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias MonisApp.Finance

  schema "transactions" do
    field :amount, :decimal
    field :note, :string
    field :payee, :string
    field :date, :date

    field :toggle, :boolean, default: false, virtual: true

    belongs_to :account, MonisApp.Finance.Account
    belongs_to :category, MonisApp.Finance.Category

    timestamps()
  end

  @doc false
  def changeset(transaction, user, attrs) do
    transaction
    |> cast(attrs, [:payee, :amount, :note, :account_id, :category_id, :date])
    |> validate_required([:payee, :amount, :category_id, :account_id, :date])
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
end
