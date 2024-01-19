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

  @spec add_message(pos_integer(), message())
    :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def add_message(room_id, message) do
    changeset(%Wtrmln.Message{}, Map.put(message, :room_id, room_id))
    |> Wtrmln.Repo.insert()
  end

  @spec get_messages(String.t(), integer()) :: list(message())
  def get_messages(room_id, limit \\ 100) do
    query = from m in Wtrmln.Message,
      where: m.room_id == ^room_id,
      order_by: [desc: m.inserted_at],
      limit: ^limit
    Wtrmln.Repo.all(query)
  end

  @spec delete_message(message :: %Wtrmln.Message{})
    :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete_message(message) do
    Wtrmln.Repo.delete(message)
  end

  defp delete_messages([]), do: {:error, "Empty message list provided"}
  defp delete_messages([hd]), do: Wtrmln.Message.delete_message(hd)
  defp delete_messages([hd | tl]) do
    Wtrmln.Message.delete_message(hd)
    delete_messages(tl)
  end

  @spec delete_messages_in_room(room_id :: pos_integer()) :: atom()
  def delete_messages_in_room(room_id) do
    query = from m in Wtrmln.Message, where: m.room_id == ^room_id
    {res, _} = Wtrmln.Repo.all(query) |> delete_messages()
    res
  end
end
