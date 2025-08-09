defmodule ChatApp.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  schema "rooms" do
    field :name, :string
    timestamps()
  end
  def changeset(r, attrs), do: r |> cast(attrs, [:name]) |> validate_required([:name]) |> unique_constraint(:name)
end
