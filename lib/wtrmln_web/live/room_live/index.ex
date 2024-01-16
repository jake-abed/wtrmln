defmodule WtrmlnWeb.RoomLive.Index do
  use WtrmlnWeb, :live_view

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
    room_id = Wtrmln.Room.get_room_id(seed)
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
    message = %{message: text, username: username, seed: seed}
    Wtrmln.send_message(message)
    WtrmlnWeb.Endpoint.broadcast(
      seed, "message", message)
    {:noreply, assign(socket, message: "")}
  end

  defp gen_username do
    "Rind#{:rand.uniform(1000)}"
  end
end
