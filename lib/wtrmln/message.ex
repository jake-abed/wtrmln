defmodule Wtrmln.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @type message()
    :: %{seed: String.t(), message: String.t(), username: String.t()}

  schema "messages" do
    field :username, :string
    field :message, :string
    belongs_to :room, Wtrmln.Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:username, :message, :room_id])
    |> validate_required([:username, :message])
  end

  @spec add_message(message())
    :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def add_message(message) do
    room_id = Wtrmln.Room.get_room_id(message.seed)
    changeset(%Wtrmln.Message{}, Map.put(message, :room_id, room_id))
    |> Wtrmln.Repo.insert()
  end

  def get_messages(seed) do
    room_id = Wtrmln.Room.get_room_id(seed)
    query = from m in Wtrmln.Message, where: m.room_id == ^room_id
    Wtrmln.Repo.all(query)
  end

  def delete_message(message) do
    Wtrmln.Repo.delete(message)
  end

  defp delete_messages([]), do: {:error, "Empty message list provided"}
  defp delete_messages([hd]), do: Wtrmln.Message.delete_message(hd)
  defp delete_messages([hd | tl]) do
    Wtrmln.Message.delete_message(hd)
    delete_messages(tl)
  end

  @spec delete_messages_in_room(seed :: String.t()) :: atom()
  def delete_messages_in_room(seed) do
    room_id = Wtrmln.Room.get_room_id(seed)
    query = from m in Wtrmln.Message, where: m.room_id == ^room_id
    {res, _} = Wtrmln.Repo.all(query) |> delete_messages()
    res
  end
end
