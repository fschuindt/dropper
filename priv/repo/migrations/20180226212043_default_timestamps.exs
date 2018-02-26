defmodule Dropper.Repo.Migrations.DefaultTimestamps do
  use Ecto.Migration

  def change do
    alter table(:payers) do
      set_default_timestamps()
    end

    alter table(:payments) do
      set_default_timestamps()
    end
  end

  defp set_default_timestamps do
    modify :inserted_at, :utc_datetime, default: fragment("NOW()")
    modify :updated_at, :utc_datetime, default: fragment("NOW()") 
  end
end
