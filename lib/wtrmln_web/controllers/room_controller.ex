defmodule WtrmlnWeb.RoomController do
  use WtrmlnWeb, :controller
  alias Wtrmln.Room, as: Room
  alias Wtrmln.Timeout, as: Timeout

  def create_seed(conn, %{"username" => "", "seed" => ""}) do
    conn
    |> put_flash(:error, "Must enter username and seed")
    |> redirect(to: ~p"/")
  end

  def create_seed(conn, %{"seed" => ""}) do
    conn
    |> put_flash(:error, "Must enter a seed")
    |> redirect(to: ~p"/")
  end

  def create_seed(conn, params) do
    seed = params["seed"]
    username = params["username"]
    timeout = params["timeout"] |> String.to_integer()
    if !Room.room_exists?(seed) do
      if (timeout > -1) do
        IO.inspect(GenServer.start_link(Timeout, {seed, timeout}, name: String.to_atom(seed <> "timeout")))
        IO.puts("I MADE A GENSERVER")
      end
      Room.create_room(seed, timeout) |> IO.inspect()
      conn
      |> redirect(to: ~p"/seed/#{seed}?username=#{username}")
    else
      conn
      |> redirect(to: ~p"/seed/#{seed}?username=#{username}")
    end
  end
end
