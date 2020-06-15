defmodule MonisApp.Finance.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :hidden, :boolean, default: false
    field :name, :string
    field :group, :string
    field :type, :string
    belongs_to :user, MonisApp.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :type, :hidden, :group])
    |> validate_required([:name, :type, :hidden, :group])
    |> validate_inclusion(:type, ["expense", "transfer", "income"])
    |> unique_constraint(:name)
  end
end
