# lib/chat_app_web/channels/user_socket.ex
defmodule ChatAppWeb.UserSocket do
  use Phoenix.Socket

  channel "room:*", ChatAppWeb.RoomChannel

  @impl true
  def connect(%{"user_name" => name}, socket, _info) when is_binary(name) do
    trimmed = String.trim(name)
    if trimmed == "" do
      :error
    else
      {:ok, assign(socket, :user_name, trimmed)}
    end
  end

  def connect(_, _socket, _info), do: :error

  @impl true
  def id(_socket), do: nil
end
