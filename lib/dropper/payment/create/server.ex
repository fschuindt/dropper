defmodule Dropper.Payment.Create.Server do
  alias Dropper.Payment
  use GRPC.Server, service: Payment.Create.Service
  # Payment.CreateResponse.new(success: true, id: "New")

  @spec payment(Payment.CreateRequest.t, GRPC.Server.Stream.t) :: Payment.CreateResponse.t
  def payment(request, _stream) do
    
  end
end
