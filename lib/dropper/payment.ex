defmodule EctoAssoc.Payment do
  use Ecto.Schema

  schema "payments" do
    field :method, :integer
    belongs_to :payer, EctoAssoc.Payer
  end
end
