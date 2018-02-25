defmodule Dropper.Payment.Create.Server do
  alias Dropper.Payment
  use GRPC.Server, service: Payment.Create.Service

  @spec perform(Payment.CreateRequest.t, GRPC.Server.Stream.t) :: Payment.CreateResponse.t
  def perform(_request, _stream) do
    Payment.CreateResponse.new(success: true, id: "New", errors: [])
  end
end
