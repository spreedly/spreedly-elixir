defmodule Spreedly.RequestBody do

  import XmlBuilder

  def add_gateway_body(gateway_type) do
    element(:gateway, gateway_type: gateway_type)
    |> generate
  end

  def add_credit_card_body(options) do
    card_fields = ~w(first_name last_name full_name month year number verification_value address1 address2 city state zip country phone_number company)a

    element(
      payment_method: [
        add(~w(email retained data)a, options),
        credit_card: add(card_fields, options)
      ])
    |> generate
  end

  def verify_body(payment_method_token) do
    element(:transaction, payment_method_token: payment_method_token)
    |> generate
  end

  defp add(symbols, options) do
    symbols |> Enum.filter_map &(options[&1]), fn(each) ->
      { each, options[each] }
    end
  end

end
