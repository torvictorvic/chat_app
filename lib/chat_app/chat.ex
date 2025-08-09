defmodule ChatApp.Chat do
  import Ecto.Query, warn: false
  alias ChatApp.Repo
  alias ChatApp.Chat.{Room, Message}

  def get_or_create_room!(name) do
    Repo.get_by(Room, name: name) ||
      Repo.insert!(Room.changeset(%Room{}, %{name: name}))
  end

  def list_recent_messages(room_id, limit \\ 50) do
    Message
    |> where([m], m.room_id == ^room_id)
    |> order_by([m], asc: m.inserted_at)
    |> preload(:user)
    |> limit(^limit)
    |> Repo.all()
  end

  def create_message!(attrs), do: Repo.insert!(Message.changeset(%Message{}, attrs))
end
