defmodule ChatApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  schema "users" do
    field :name, :string
    timestamps()
  end
  def changeset(u, attrs), do: u |> cast(attrs, [:name]) |> validate_required([:name]) |> unique_constraint(:name)
end
