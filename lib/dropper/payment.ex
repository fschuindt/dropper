defmodule Dropper.Payment do
  use Ecto.Schema

  schema "payments" do
    field :payer_id, :integer
    field :method, :integer
  end

  def changeset(payment, params \\ %{}) do
    payment
    |> Ecto.Changeset.cast(params, [:payer_id, :method])
    |> Ecto.Changeset.validate_required([:payer_id])
  end
end
