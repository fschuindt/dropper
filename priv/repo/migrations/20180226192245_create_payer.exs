defmodule Dropper.Repo.Migrations.CreatePayer do
  use Ecto.Migration

  def change do
    create table(:payers) do
      add :name, :string
      add :email, :string

      timestamps()
    end
  end
end
