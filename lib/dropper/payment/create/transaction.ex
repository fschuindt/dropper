defmodule Dropper.Payment.Create.Transaction do
  def create_payer(request) do
    %Dropper.Payer{}
    |> Dropper.Payer.changeset(payer_attributes(request))
    |> Dropper.Repo.insert()
  end

  def create_payment(request, payer) do
    %Dropper.Payment{}
    |> Dropper.Payment.changeset(payment_attributes(request, payer))
    |> Dropper.Repo.insert()
  end

  defp payer_attributes(request) do
    payer = request.payer
    %{name: name, email: email} = %{name: payer.name, email: payer.email}
  end

  defp payment_attributes(request, payer) do
    %{payer_id: payer_id, method: method} = %{payer_id: payer.id, method: request.method}
  end
end
