defmodule Spreedly.Transaction.Verify do

  defstruct ~w(token succeeded state message retained payment_method order_id ip description gateway_token gateway_transaction_id
               email merchant_name_descriptor merchant_location_descriptor on_test_gateway)a


  def new_from_xml(xml) do
    transaction = XML.into_struct(xml, __MODULE__, [:payment_method])
    %{ transaction | payment_method: retrieve_payment_method(xml) }
  end

  defp retrieve_payment_method(xml) do
    node = XPath.select(xml, "//payment_method") |> List.first
    Spreedly.CreditCard.new_from_xml(node)
  end

end
