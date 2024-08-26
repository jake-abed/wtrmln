defmodule WtrmlnWeb.RoomLive.Index do
  use WtrmlnWeb, :live_view
  alias Wtrmln.Timeout, as: Timeout

  def mount(params, _session, socket) when params == %{} do
    {:noreply, push_navigate(socket, to: "/")}
  end

  def mount(params, _session, socket) do
    seed = params["seed"]
    if connected?(socket) do
      WtrmlnWeb.Endpoint.subscribe(seed)
    end
    username =
      if params["username"] do
        params["username"]
      else
        gen_username()
      end
    {room_id, _timeout} = IO.inspect(Wtrmln.Room.get_room_info(seed))
    messages = Wtrmln.Message.get_messages(room_id, 100) |> Enum.reverse()
    WtrmlnWeb.Endpoint.broadcast(seed, "join", %{username: username})
    {:ok, assign(socket, seed: seed, username: username, messages: messages, message: "")}
  end

  def handle_info(%{event: "message", payload: message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  def handle_info(%{event: "join", payload: message}, socket) do
    {:noreply, put_flash(socket, :info, "#{message.username} joined the seed.")}
  end

  def handle_info(%{event: "spit", payload: _message}, socket) do
    {:noreply, push_navigate(socket, to: "/")}
  end

  def handle_event("spit", %{"seed" => seed}, socket) do
    Wtrmln.spit_seed(seed)
    WtrmlnWeb.Endpoint.broadcast(
      seed, "spit", %{seed: seed, username: socket.assigns.username})
    {:noreply, socket}
  end

  def handle_event("send", %{"message" => text, "username" => username, "seed"=> seed}, socket) do
    {_, timeout} = Wtrmln.Room.get_room_info(seed)
    message = %{message: text, username: username, seed: seed}

    {_, %Wtrmln.Message{id: id}} = Wtrmln.send_message(message)
    pid = GenServer.whereis(String.to_atom(seed <> "timeout"))

    IO.puts("A MESSAGE HAPPENED")

    if (pid) do
      Timeout.message(pid, timeout)
    end

    WtrmlnWeb.Endpoint.broadcast(seed, "message", Map.put(message, :id, id))
    {:noreply, assign(socket, message: "")}
  end

  defp gen_username do
    "Rind#{:rand.uniform(1000)}"
  end
end
