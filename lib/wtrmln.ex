defmodule Wtrmln do
  @moduledoc """
  Wtrmln keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
"""
    def send_message(message) do
    room_id = Wtrmln.Room.get_room_id(message.seed)
    Wtrmln.Message.add_message(room_id, message)
  end

  def spit_seed(seed) do
    cond do
      !Wtrmln.Room.room_exists?(seed) ->
        {:error, "No such seed!"}
      true ->
        room_id = Wtrmln.Room.get_room_id(seed)
        Wtrmln.Message.delete_messages_in_room(room_id)
        Wtrmln.Room.delete_room(room_id)
    end
  end
end
