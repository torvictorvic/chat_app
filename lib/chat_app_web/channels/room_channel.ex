defmodule ChatAppWeb.RoomChannel do
  use Phoenix.Channel
  alias ChatApp.{Accounts, Chat}
  alias ChatAppWeb.Presence

  @impl true
  def join("room:" <> room_name, _params, socket) do
    room = Chat.get_or_create_room!(room_name)
    recent = Chat.list_recent_messages(room.id) |> Enum.map(&as_map/1)
    {:ok, %{messages: recent}, assign(socket, room: room)}
  end

  @impl true
  def handle_in("presence_subscribe", _payload, socket) do
    user = Accounts.get_or_create_user_by_name!(socket.assigns.user_name)
    {:ok, _} = Presence.track(socket, user.name, %{online_at: System.system_time(:second)})
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  @impl true
  def handle_in("message:new", %{"body" => body}, socket) when is_binary(body) and body != "" do
    %{room: room} = socket.assigns
    user = Accounts.get_or_create_user_by_name!(socket.assigns.user_name)
    msg = Chat.create_message!(%{body: body, user_id: user.id, room_id: room.id})
    payload = %{user: user.name, body: msg.body, at: DateTime.utc_now()}
    broadcast!(socket, "message:created", payload)
    {:reply, {:ok, payload}, socket}
  end

  def handle_in(_, _, socket), do: {:noreply, socket}

  defp as_map(m), do: %{user: m.user.name, body: m.body, at: m.inserted_at}
end
