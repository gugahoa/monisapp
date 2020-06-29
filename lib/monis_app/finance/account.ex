defmodule MonisApp.Finance.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :starting_balance, :decimal, default: 0
    field :is_active, :boolean, default: true
    field :type, :string, null: false
    field :name, :string, null: false

    belongs_to :user, MonisApp.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:starting_balance, :is_active, :type, :name])
    |> validate_required([:starting_balance, :is_active, :type, :name])
    |> unique_constraint(:name)
  end
end
