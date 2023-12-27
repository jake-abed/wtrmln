defmodule WtrmlnWeb.RoomController do
  use WtrmlnWeb, :controller
  alias Wtrmln.Room, as: Room

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
    if !Room.room_exists?(seed) do
      Room.create_room(seed)
      conn
      |> redirect(to: ~p"/seed/#{seed}?username=#{username}")
    else
      conn
      |> redirect(to: ~p"/seed/#{seed}?username=#{username}")
    end
  end
end
