defmodule Dropper.Payment.Create.Server do
  alias Dropper.Payment
  use GRPC.Server, service: Payment.Create.Service

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
    Payment.CreateResponse.new(success: false)
  end

  defp finish({:ok, payment}, payer) do
    payer_data = "Payer: #{payer.name} <#{payer.email}>"
    payment_data = "Method: #{payment.method}"

    Payment.CreateResponse.new(success: true, id: "#{payer_data} | #{payment_data}")
  end

  defp finish({:error, _changeset}, _payer) do
    Payment.CreateResponse.new(success: false)
  end
end
