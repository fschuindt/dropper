defmodule Dropper.Payer do
  use Ecto.Schema

  schema "payers" do
    field(:name, :string)
    field(:email, :string)

    has_many(:payments, Dropper.Payment, on_delete: :delete_all)
  end

  def changeset(payer, params \\ %{}) do
    payer
    |> Ecto.Changeset.cast(params, [:name, :email])
    |> Ecto.Changeset.validate_required([:email])
  end
end
