defmodule Dropper.Repo.Migrations.CreatePayers do
  use Ecto.Migration

  def change do
    create table(:payers) do
      add :name, :string
      add :email, :string
    end
  end
end
