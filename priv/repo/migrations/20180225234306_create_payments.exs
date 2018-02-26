defmodule Dropper.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :payer_id, :integer
      add :method, :integer
    end
  end
end
