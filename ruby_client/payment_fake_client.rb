require 'grpc'
require_relative 'payment_pb'
require_relative 'payment_services_pb'
require 'faker'

class PaymentFakeClient
  def initialize
    @stub = Dropper::Payment::Stub
      .new('localhost:50051', :this_channel_is_insecure)
  end

  def push(many)
    @many = many

    self
  end

  def perform_sequential
    @many.times do
      message = @stub.payment(payment)

      p "#{message.inspect}"
    end
  end

  private

  def payer
    Dropper::Payment::Payer.new(
      name: Faker::Name.name,
      email: Faker::Internet.email
    )
  end

  def payment
    Dropper::Payment::CreateRequest.new(
      payer: payer,
      method: rand(0..2)
    )
  end
end
