defmodule Dropper.Payment.Create.Transaction do
  @moduledoc """
  Describes a set of database actions regarding the Payment creation.
  """

  @doc """
  Given a proper gRPC request, it will cast Ecto to create a
  `Dropper.Payer`.
  """
  @spec create_payer(Dropper.Payment.CreateRequest.t) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def create_payer(request) do
    %Dropper.Payer{}
    |> Dropper.Payer.changeset(payer_attributes(request))
    |> Dropper.Repo.insert()
  end

  @doc """
  Given a proper gRPC request and a created `Dropper.Payer`, it will
  cast Ecto to create a `Dropper.Payment`.
  """
  @spec create_payment(Dropper.Payment.CreateRequest.t, Ecto.Schema.t) :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}
  def create_payment(request, payer) do
    %Dropper.Payment{}
    |> Dropper.Payment.changeset(payment_attributes(request, payer))
    |> Dropper.Repo.insert()
  end

  @spec payer_attributes(Dropper.Payment.CreateRequest.t) :: %{name: String.t, email: String.t}
  defp payer_attributes(request) do
    %{name: _name, email: _email} = %{name: request.payer.name, email: request.payer.email}
  end

  @spec payment_attributes(Dropper.Payment.CreateRequest.t, Ecto.Schema.t) :: %{payer_id: integer, method: integer}
  defp payment_attributes(request, payer) do
    %{payer_id: _payer_id, method: _method} = %{payer_id: payer.id, method: request.method}
  end
end
