defmodule Spreedly.Transaction do

  defstruct ~w(token succeeded state message payment_method transaction_type xml)a

  def new_from_xml(xml) do
    transaction = XML.into_struct(xml, __MODULE__, [:payment_method])
    %{ transaction | payment_method: retrieve_payment_method(xml) }
  end

  defp retrieve_payment_method(xml) do
    node = XPath.select(xml, "//payment_method") |> List.first
    Spreedly.PaymentMethod.new_from_xml(node)
  end

end
