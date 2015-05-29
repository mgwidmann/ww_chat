defmodule WwChat.RoomChannel do
  use WwChat.Web, :channel
  alias WwChat.Activity

  def join("rooms:lobby", %{"user" => name}, socket) do
    socket = assign(socket, :user, name)
    {:ok, socket}
  end

  def handle_in("new:message", %{"message" => message}, socket) do
    payload = %{user: socket.assigns.user, message: message}
    broadcast! socket, "new:message", payload
    # Activity.changeset(%Activity{}, payload)
    # |> Repo.insert
    {:noreply, socket}
  end

  def handle_in("user:change", %{"renamed" => new_name}, socket) do
    broadcast! socket, "user:change", %{user: socket.assigns.user, renamed: new_name}
    socket = assign(socket, :user, new_name)
    {:noreply, socket}
  end

  def handle_in("user:type", %{"typing" => is_typing}, socket) do
    broadcast! socket, "user:type", %{user: socket.assigns.user, typing: is_typing}
    {:noreply, socket}
  end

end
