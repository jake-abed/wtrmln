defmodule Wtrmln do
  @moduledoc """
  Wtrmln keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
"""
  @spec send_message(map()) :: :ok | :error
  def send_message(message) do
    with Wtrmln.Room.room_exists?(message.seed),
         room_id <- Wtrmln.Room.get_room_id(message.seed),
         {:ok, _} <- Wtrmln.Message.add_message(room_id, message) do
      :ok
    end
  end
  
  @spec spit_seed(seed :: String.t()) :: :ok | :error
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
