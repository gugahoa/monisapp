defmodule MonisApp.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :decimal
    field :note, :string
    field :payee, :string

    field :toggle, :boolean, default: false, virtual: true

    belongs_to :account, MonisApp.Finance.Account
    belongs_to :category, MonisApp.Finance.Category

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:payee, :amount, :note, :account_id, :category_id])
    |> validate_required([:payee, :amount, :category_id, :account_id])
  end

  @doc false
  def form_changeset(transaction, attrs) do
    transaction
    |> changeset(attrs)
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
