defmodule EctoAssoc.Payer do
  use Ecto.Schema

  schema "payers" do
    field :name, :string
    field :email, :string

    has_many :payments, EctoAssoc.Payment, on_delete: :delete_all
  end
end
