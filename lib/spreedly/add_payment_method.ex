defmodule Spreedly.AddPaymentMethod do

  defstruct ~w(token succeeded state message retained payment_method)a

  def new_from_xml(xml) do
    transaction = XML.into_struct(xml, %Spreedly.AddPaymentMethod{}, [:payment_method])

    payment_method_node = XPath.select(xml, "//payment_method") |> List.first
    payment_method = Spreedly.CreditCard.new_from_xml(payment_method_node)

    %{ transaction | payment_method: payment_method }
  end

end
