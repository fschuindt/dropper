module Dropper
  module Payment
    class Service
      include GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'dropper.payment.Create'

      rpc :Payment, CreateRequest, CreateResponse
    end

    Stub = Service.rpc_stub_class
  end
end
