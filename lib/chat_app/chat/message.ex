defmodule ChatApp.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  schema "messages" do
    field :body, :string
    belongs_to :user, ChatApp.Accounts.User
    belongs_to :room, ChatApp.Chat.Room
    timestamps(updated_at: false)
  end
  def changeset(m, attrs), do: m |> cast(attrs, [:body, :user_id, :room_id]) |> validate_required([:body, :user_id, :room_id])
end
