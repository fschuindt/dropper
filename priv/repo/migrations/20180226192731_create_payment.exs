defmodule Dropper.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :payer_id, references(:payers)
      add :method, :integer

      timestamps()
    end
  end
end
