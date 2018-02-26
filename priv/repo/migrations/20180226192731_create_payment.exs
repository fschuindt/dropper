defmodule Dropper.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :payer_id, references(:payers)
      add :method, :integer, default: 0

      timestamps()
    end
  end
end
