defmodule Wtrmln do
  @moduledoc """
  Wtrmln keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def spit_seed(seed) do
    cond do
      !Wtrmln.Room.room_exists?(seed) ->
        {:error, "No such seed!"}
      true ->
        Wtrmln.Message.delete_messages_in_room(seed)
        Wtrmln.Room.delete_room(seed)
    end
  end
end
