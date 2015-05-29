defmodule WwChat.Listener do
  alias Phoenix.Socket.Broadcast
  alias WwChat.Activity
  alias WwChat.Repo
  require Logger

  def start_link() do
    pid = spawn_link __MODULE__, :listen, []
    WwChat.Endpoint.subscribe pid, "rooms:lobby"
    {:ok, pid}
  end

  def listen() do
    receive do
      %Broadcast{event: "new:message", payload: pl} ->
        Activity.changeset(%Activity{}, pl)
        |> Repo.insert
      _ -> nil
    end
    listen
  end
end
