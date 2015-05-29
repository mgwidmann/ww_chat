defmodule WwChat.Listener do
  alias Phoenix.Socket.Broadcast
  alias WwChat.Activity
  alias WwChat.Repo
  require Logger

  def start_link() do
    pid = spawn_link __MODULE__, :listen, []
    case :global.register_name :listener, pid, &:global.random_exit_name/3 do
      :yes ->
        WwChat.Endpoint.subscribe pid, "rooms:lobby"
      :no ->
        Process.monitor(:global.whereis_name(:listener))
        Logger.debug "Already a WwChat.Listener in this cluster, I'm going to sleep... zzzZZZ"
        send(pid, :sleep)
    end
    {:ok, pid}
  end

  def listen() do
    receive do
      %Broadcast{event: "new:message", payload: pl} ->
        Activity.changeset(%Activity{}, pl)
        |> Repo.insert
      :sleep ->
        :timer.sleep(:infinity)
      _ -> nil
    end
    listen
  end
end
