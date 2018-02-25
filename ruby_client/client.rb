require 'grpc'
require_relative 'payment_pb'
require_relative 'payment_services_pb'

class Client
  def self.perform
    stub = Dropper::Payment::Stub.new('localhost:50051', :this_channel_is_insecure)
    message = stub.payment(Dropper::Payment::CreateRequest.new())
    p "#{message.inspect}"
  end
end

Client.perform
