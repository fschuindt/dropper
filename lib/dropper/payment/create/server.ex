defmodule Dropper.Payment.Create.Server do
  alias Dropper.Payment
  use GRPC.Server, service: Payment.Create.Service

  @spec payment(Payment.CreateRequest.t, GRPC.Server.Stream.t) :: Payment.CreateResponse.t
  def payment(_request, _stream) do
    Payment.CreateResponse.new(success: true, id: "New")
  end
end
