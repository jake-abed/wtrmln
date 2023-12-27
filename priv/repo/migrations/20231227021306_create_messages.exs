defmodule Wtrmln.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :username, :string
      add :message, :string
      add :room_id, references(:rooms)

      timestamps(type: :utc_datetime)
    end
  end
end
