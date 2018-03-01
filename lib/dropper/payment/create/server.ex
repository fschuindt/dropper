defmodule Dropper.Payment.Create.Server do
  alias Dropper.Payment
  use GRPC.Server, service: Payment.Create.Service

  @moduledoc """
  A gRPC server implementation for the creation of `Dropper.Payer`
  and `Dropper.Payment` Ecto related entities. See
  `lib/dropper/payment/payment.pb.ex` and
  `proto/payment.proto` files for the gRPC definition.
  """

  @doc """
  Recieves the gRPC request and stream. Performs the
  `Dropper.Payment.Create.Transaction` functions and replies with a
  relative gRPC response.

  As it implements the `GRPC.Server` almost like a behaviour, the
  stream (which is unnecessary here) is ignored but present to
  maintain the API function arity.
  """
  @spec payment(Payment.CreateRequest.t(), GRPC.Server.Stream.t()) :: Payment.CreateResponse.t()
  def payment(request, _stream) do
    Payment.Create.Transaction.create_payer(request)
    |> create_payment(request)
  end

  defp create_payment({:ok, payer}, request) do
    Payment.Create.Transaction.create_payment(request, payer)
    |> finish(payer)
  end

  defp create_payment({:error, _changeset}, _request) do
    Payment.CreateResponse.new(success: false, errors: errors(:missing_payer))
  end

  defp finish({:ok, payment}, _payer) do
    payment_id = Integer.to_string(payment.id)
    Payment.CreateResponse.new(success: true, id: payment_id)
  end

  defp finish({:error, _changeset}, _payer) do
    Payment.CreateResponse.new(success: false, errors: errors(:missing_payment))
  end

  defp errors(:missing_payer) do
    %{"missing_payer" => "Error when trying to create a Payer."}
  end

  defp errors(:missing_payment) do
    %{"missing_payment" => "Error when trying to create a Payment."}
  end
end
