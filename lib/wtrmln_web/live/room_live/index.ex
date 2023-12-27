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
    {:ok, assign(socket, seed: seed, username: username, messages: [])}
  end

  def handle_info(%{event: "message", payload: message}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  def handle_event("send", %{"message" => text, "seed"=> seed}, socket) do
    WtrmlnWeb.Endpoint.broadcast(seed, "message", %{message: text, name: socket.assigns.username})
    {:noreply, socket}
  end

  defp gen_username do
    "Rind#{:rand.uniform(1000)}"
  end
end
