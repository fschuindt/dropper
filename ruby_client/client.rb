require_relative 'payment_fake_client'

PaymentFakeClient.new.push(4).perform_sequential
