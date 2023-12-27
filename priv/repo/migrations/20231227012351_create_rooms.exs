defmodule Wtrmln.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :seed, :string

      timestamps(type: :utc_datetime)
    end
  end
end
